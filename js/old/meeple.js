//
class meeple {
  constructor ( index, center, cell, team ){
    this.const = {
      index: index,
      period: 12,
      frame: 2,
      team: team,
      a: cellSize / 2,
      n: 6
    };
    this.const.r = this.const.a / ( Math.tan( Math.PI / 6 ) * 2 );
    this.array = {
      pointer: [],
      danger: [],
      vertex: [],
      dot: [],
      way: [],
      bar: []
    };
    this.var = {
      orientation: 1,
      clockwise: true,
      priority: 'sleep',//sleep spend fill convergence//'automaticAttack' specialAttack
      complete: false,
      movesIn: null,
      forward: true,
      stopped: false,
      center: center.copy(),
      scheme: 'killAllEnemies',
      action: 'waiting',
      status: 'frozen',
      stage: null,
      timer: null,
      stop: null,
      cell: cell,
      color:{
        h: null,
        s: null,
        l: null
      },
      speed: {
        move: 0.5,
        rotate: 0.25
      },
      target: {
        cell: null,
        meeple: null
      },
      damage: 34,
      angle: 0,
      beat: 1 //tact
    }
    this.data = {
      'health': {
        current: 100,
        max : 100
      },
      'mana': {
        current: 0,
        max : 100
      }
    }
    this.var.stop = fr * this.var.speed.rotate;

    this.init();
  }

  initVertexs(){
    for( let i = 0; i < this.const.n; i++ ){
      let vec = createVector(
        Math.sin( Math.PI * 2 / this.const.n * ( - i + this.const.n / 2 ) ) * this.const.a,
        Math.cos( Math.PI * 2 / this.const.n * ( - i + this.const.n / 2 ) ) * this.const.a );
      this.array.vertex.push( vec );
    }
  }

  initPointers(){
    for( let i = 0; i < this.const.n; i++ ){
      let vec = createVector(
        Math.sin( Math.PI * 2 / this.const.n * ( 0.5 - i + this.const.n / 2 ) ) * this.const.a * 1.2,
        Math.cos( Math.PI * 2 / this.const.n * ( 0.5 - i + this.const.n / 2 ) ) * this.const.a * 1.2 );
      this.array.pointer.push( vec );
    }
  }

  initWays(){
    for( let i = 0; i < this.const.n; i++ ){
      let vec = createVector(
        Math.sin( Math.PI * 2 / this.const.n * ( - 0.5 - i + this.const.n / 2 ) ) * this.const.r * 4,
        Math.cos( Math.PI * 2 / this.const.n * ( - 0.5 - i + this.const.n / 2 ) ) * this.const.r * 4);
      this.array.way.push( vec );
    }
  }

  initBars(){
    this.array.bar.push( new  bar( createVector(), 7, 'health' ) );
    this.array.bar.push( new  bar( createVector(), 8, 'mana' ) );
    this.array.bar[0].setPoints( this.data['health'] );
    this.array.bar[1].setPoints( this.data['mana'] );
  }

  initColor(){
    switch ( this.const.team ) {
      case 0:
        this.var.color.h = 120;
        this.var.color.s = colorMax;
        this.var.color.l = colorMax;
        break;
      case 1:
        this.var.color.h = 0;
        this.var.color.s = colorMax;
        this.var.color.l = 0;
        break;
    }
  }

  init(){
    this.initVertexs();
    this.initPointers();
    this.initWays();
    this.initBars();
    this.initColor();
  }

  setCell( index ){
    this.var.cell = index;
    this.array.dot = [];
  }

  setNext( index ){
    this.var.movesIn = index;
  }

  setAction( action ){
    let vec;
    let origin;

    switch ( action ) {
      case 0:
        this.var.action = 'waiting';
        break;
      case 1:
        this.var.action = 'moving';
        this.array.dot = [];
        vec = this.array.way[this.var.orientation].copy();
        origin = this.array.way[this.var.orientation].copy();
        origin.normalize();
        origin.mult( this.const.r );
        vec.div( 2 );
        vec.add( this.var.center.copy() );
        vec.sub( origin );
        this.array.dot.push( vec.copy() );
        vec.add( origin );
        vec.add( origin );
        this.array.dot.push( vec.copy() );
        vec.add( origin );
        this.array.dot.push( vec.copy() );
        break;
      case 2:
        this.var.action = 'clockwiseRotating';
        this.var.clockwise = true;
        this.var.timer = 0;
        break;
      case 3:
        this.var.action = 'counterClockwiseRotating';
        this.var.clockwise = false;
        this.var.timer = 0;
        break;
      case 4:
        this.var.action = 'attacking';
        this.array.dot = [];
        this.array.dot.push( this.var.center.copy() );
        vec = this.array.way[this.var.orientation].copy();
        origin = this.array.way[this.var.orientation].copy();
        origin.normalize();
        origin.mult( this.const.r );
        vec.div( 2 );
        vec.add( this.var.center.copy() );
        vec.sub( origin );
        this.array.dot.push( vec.copy() );
        break;
    }
  }

  setPriority( prior, meeples ){
    switch ( prior ) {
      case 0:
        this.var.priority = 'sleep';
        this.setAction( 0 );
        break;
      case 1:
        this.var.priority = 'convergence';
        this.selectTarget( meeples );
        break;
      case 2:
        this.var.priority = 'attack';
        this.setAction( 4 );
        break;
      case 3:
        this.var.priority = 'search';
        this.setAction( 5 );
        break;
    }
  }

  setStatus( status, meeples ){
    switch ( status ) {
      case 0:
        this.var.status = 'frozen';
        break;
      case 1:
        this.var.status = 'onWay';
        this.selectTarget( meeples );
        this.setPriority( 1, meeples );
        break;
      case 2:
        this.var.status = 'at??heReady';
        this.setPriority( 2 );
        break;
      case 3:
        this.var.status = 'enemyEliminated';
        this.setPriority( 0 );
        break;
      case 4:
        this.var.status = 'victory';
        this.setPriority( 0 );
        break;
      }
  }

  addThreat( meeple ){
    this.array.danger.push( {
      target: meeple,
      value: meeple * 2
    } );
  }

  removeThreat( meeple ){
    for( let i = 0; i < this.array.danger.length; i++ ){
      if( this.array.danger[i].target == meeple )
          this.array.danger[i].value = -1;
    }
  }

  sortThreats(){
    let temp;

    for( let i = 0; i < this.array.danger.length - 1; i++ ){
      let finish = true;
      for( let j = 0; j < this.array.danger.length - 1 - i; j++ )
        if ( this.array.danger[j].value < this.array.danger[j + 1].value ) {
            temp = this.array.danger[j];
            this.array.danger[j] = this.array.danger[j + 1];
            this.array.danger[j + 1] = temp;
            finish = false;
        }
      if( finish )
        return;
    }
  }

  selectTarget( meeples ){
    this.sortThreats();
    if( this.allThreatsAreEliminated() ){
      this.setStatus( 4 );
      //this.var.stopped = true;
      return;
    }

    let index = this.array.danger[0].target;
    let cell = meeples[index].var.cell;
    this.var.target = index;
  }

  allThreatsAreEliminated(){
    return this.array.danger[0].value == -1;
  }

  takeDamge( dmg ){
    let points = this.data['health'].current -= dmg;
    this.array.bar[0].updatePoints( points )
  }

  makeDamage( meeples ){
    let dmg = this.var.damage;
    let victim = meeples[this.var.target];
    victim.takeDamge( dmg );
  }

  isAlive(){
    return this.data['health'].current > 0;
  }

  draw(){
    noStroke();
    for( let i = 0; i < this.array.vertex.length; i++ ){
      let ii = ( i + 1 ) % this.array.vertex.length;
      fill( this.var.color.h, this.var.color.s, this.var.color.l );
      triangle( this.var.center.x, this.var.center.y,
                this.array.vertex[i].x  + this.var.center.x, this.array.vertex[i].y + this.var.center.y,
                this.array.vertex[ii].x + this.var.center.x, this.array.vertex[ii].y + this.var.center.y );
      if( i == this.var.orientation ){
        fill( this.var.color.h, this.var.color.s, this.var.color.l );
        triangle( this.array.pointer[ii].x  + this.var.center.x, this.array.pointer[ii].y + this.var.center.y,
                  this.array.vertex[i].x  + this.var.center.x, this.array.vertex[i].y + this.var.center.y,
                  this.array.vertex[ii].x + this.var.center.x, this.array.vertex[ii].y + this.var.center.y );
      }
     }

     for( let i = 0; i < this.array.bar.length; i++ )
        this.array.bar[i].draw( this.var.center );

     noFill();
  }
}
