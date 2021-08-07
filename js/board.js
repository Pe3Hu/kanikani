class board{
  constructor(){
    this.const = {
      workspace_size_x: CONST_A * 30,
      workspace_size_y: CONST_A * 20,
      a: 2,
      n: 6,
      radius: 0
    };
    this.var = {
      index: {
        vertex: 0,
        cell: 0,
        center: -1
      },
      current: {
        cell_cluster: {
          x: 0,
          y: 0
        }
      },
      theta: 0
    };
    this.flag = {}
    this.array = {
      vertex: [],
      cell: [],
      row_size: [],
      row_first_vertex: [],
      gate: [],
    };
    this.data = {
      renderer: null,
      scene: null,
      camera: null,
      stats: null,
      uniforms: null,
      geometry: {
        map: null
      },
      hues: {
      }
    };

    this.init();
  }

  init() {
    this.const.radius = this.const.workspace_size_x + this.const.workspace_size_y;
    this.const.r = this.const.a / ( Math.tan( Math.PI / 6 ) * 2 );
    this.const.rows = Math.round( this.const.workspace_size_y * 2.3 / ( CONST_A * this.const.r * 2 ) );
    this.const.cols = Math.round( this.const.workspace_size_x * 1.7 / ( CONST_A * this.const.a * 1.5 ) );
    this.init_main();
    this.init_cells();
    this.init_gates();
    this.cells_around_center();
    this.init_geometrys();
    this.init_paint();
  }

  init_main(){
    WORKSPACE = new THREE.Vector3(
      this.const.workspace_size_x,
      this.const.workspace_size_y,
      0
    );
    MAX_DIST = Math.sqrt( Math.pow( WORKSPACE.x * 2, 2 ) + Math.pow( WORKSPACE.y * 2, 2 ) );

    this.data.camera = new THREE.PerspectiveCamera( 60, window.innerWidth / window.innerHeight, 1, 10000 );
  	this.data.camera.position.x = this.const.radius * Math.sin( THREE.MathUtils.degToRad( this.var.theta ) );
		this.data.camera.position.y = this.const.radius * Math.sin( THREE.MathUtils.degToRad( this.var.theta ) );
		this.data.camera.position.z = this.const.radius * Math.cos( THREE.MathUtils.degToRad( this.var.theta ) );


		this.data.camera.updateMatrixWorld();

    this.data.scene = new THREE.Scene();
		this.data.camera.lookAt( this.data.scene.position );

    this.data.renderer = new THREE.WebGLRenderer();
    this.data.renderer.setPixelRatio( window.devicePixelRatio );
    this.data.renderer.setSize( window.innerWidth, window.innerHeight );

    let container = document.getElementById( 'container' );
    container.appendChild( this.data.renderer.domElement );

    this.data.stats = new Stats();
    container.appendChild( this.data.stats.dom );

    this.data.clock = new THREE.Clock( true );

		this.data.raycaster = new THREE.Raycaster();

		this.data.pointer = new THREE.Vector2();

    this.data.scene.add( new THREE.AmbientLight( 0xffffff ) );
  }

  init_geometrys(){
    //

    const triangles = this.array.cell.length * 4;
    const positions = new Float32Array( triangles * 3 * 3 );
    const normals = new Float32Array( triangles * 3 * 3 );
    const colors = new Float32Array( triangles * 3 * 3 );

    const pA = new THREE.Vector3();
    const pB = new THREE.Vector3();
    const pC = new THREE.Vector3();

    const cb = new THREE.Vector3();
    const ab = new THREE.Vector3();

    const color = new THREE.Color();

    for ( let cell of this.array.cell )
      if( cell.flag.in_cirlce ){
        let shifted_index = cell.const.index * 4 * 9;

        for ( let j = 1; j < cell.array.vertex.length - 2; j++ ){
          let i = shifted_index + ( j - 1 ) * 9;

          const ax = this.array.vertex[cell.array.vertex[0]].x;
          const ay = this.array.vertex[cell.array.vertex[0]].y;
          const az = this.array.vertex[cell.array.vertex[0]].z;

          const bx = this.array.vertex[cell.array.vertex[j]].x;
          const by = this.array.vertex[cell.array.vertex[j]].y;
          const bz = this.array.vertex[cell.array.vertex[j]].z;

          const cx = this.array.vertex[cell.array.vertex[j + 1]].x;
          const cy = this.array.vertex[cell.array.vertex[j + 1]].y;
          const cz = this.array.vertex[cell.array.vertex[j + 1]].z;

          positions[ i ] = ax;
          positions[ i + 1 ] = ay;
          positions[ i + 2 ] = az;

          positions[ i + 3 ] = bx;
          positions[ i + 4 ] = by;
          positions[ i + 5 ] = bz;

          positions[ i + 6 ] = cx;
          positions[ i + 7 ] = cy;
          positions[ i + 8 ] = cz;

          color.setHSL( 1, 1, 1 );//cell.data.hue

          pA.set( ax, ay, az );
          pB.set( bx, by, bz );
          pC.set( cx, cy, cz );

          cb.subVectors( pC, pB );
          ab.subVectors( pA, pB );
          cb.cross( ab );

          cb.normalize();

          const nx = cb.x;
          const ny = cb.y;
          const nz = cb.z;

          normals[ i ] = nx;
          normals[ i + 1 ] = ny;
          normals[ i + 2 ] = nz;

          normals[ i + 3 ] = nx;
          normals[ i + 4 ] = ny;
          normals[ i + 5 ] = nz;

          normals[ i + 6 ] = nx;
          normals[ i + 7 ] = ny;
          normals[ i + 8 ] = nz;

          colors[ i ] = color.r;
          colors[ i + 1 ] = color.g;
          colors[ i + 2 ] = color.b;

          colors[ i + 3 ] = color.r;
          colors[ i + 4 ] = color.g;
          colors[ i + 5 ] = color.b;

          colors[ i + 6 ] = color.r;
          colors[ i + 7 ] = color.g;
          colors[ i + 8 ] = color.b;
        }
    }

    this.data.geometry.map = new THREE.BufferGeometry();
    this.data.geometry.map.setAttribute( 'position', new THREE.BufferAttribute( positions, 3 ) );
    this.data.geometry.map.setAttribute( 'normal', new THREE.BufferAttribute( normals, 3 ) );
    this.data.geometry.map.setAttribute( 'color', new THREE.BufferAttribute( colors, 3 ) );
    let material = new THREE.MeshPhongMaterial( {
            color: 0xaaaaaa, specular: 0xffffff, shininess: 250,
            side: THREE.DoubleSide, vertexColors: true
          } );

    this.data.map = new THREE.Mesh( this.data.geometry.map, material );
    this.data.scene.add( this.data.map )

    this.data.raycaster = new THREE.Raycaster();

    this.data.pointer = new THREE.Vector2();
  }

  init_cells(){
    for( let i = 0; i < this.const.rows; i++ ){
      this.array.row_first_vertex.push( this.array.vertex.length );
      let old_row_sizes = 0;

      if( i > 0 )
         old_row_sizes = this.array.row_size[i - 1];

      let other_shifts = [
        [ 4, 3 ],
        [ 4, 3, 2 ],
        [ 1 ]
      ];

      let first;
      let vertex_index = 0;

      for( let j = 0; j < this.const.cols; j++ ){
        let first = 0;

        if( i == 0 ){
          vertex_index = this.array.vertex.length - other_shifts[0][1];

          if( j == 0 )
            vertex_index = 0;

          if( j == 1 )
            vertex_index = this.array.vertex.length - other_shifts[0][0];
        }

        if( i > 0 ){
          if( i % 2 == 1 ){
            if( j == 0 ){

              vertex_index = this.array.row_first_vertex[i - 1] + other_shifts[1][0];

              if( i > 1 )
                vertex_index -= 3;
            }

            if( j == 1 ){
              first = 5;
              vertex_index = this.array.vertex.length - other_shifts[1][1];
            }

            if( j > 1 ){
              first = 5;
              vertex_index = this.array.vertex.length - other_shifts[1][2];
            }
          }

          if( i % 2 == 0 ){
            if( j == 0 ){
              first = 2;
              vertex_index = this.array.row_first_vertex[i - 1] + other_shifts[2][0];
            }

            if( j > 1 ){
              first = 5;
              vertex_index = this.array.vertex.length - other_shifts[1][2];
            }
          }
        }

        this.set_cell( first, vertex_index );
      }

      this.array.row_size.push( this.array.vertex.length - this.array.row_first_vertex[i] );
    }

    let center = {
      d: INFINITY,
      index: -1
    };

    for ( let cell of this.array.cell ){
      let d = cell.const.center.distanceTo( new THREE.Vector3() );

      if( center.d > d )
        center = {
          d: d,
          index: cell.const.index
        };
    }

    this.var.index.center = center.index;
  }

  init_gates(){
    for( let cell of this.array.cell ){
      let gates = [];

      for ( let l = 0; l < cell.array.vertex.length - 1; l++ ){
        let ll = ( l + 1 ) % cell.array.vertex.length;

        let vertex_indexs = [
          cell.array.vertex[l],
          cell.array.vertex[ll]
        ];

        let flag = false;
        let already_index = null;

        for( let i = 0; i < this.array.gate.length; i++ )
          if( !flag ){
            let gate = this.array.gate[i];
            flag = flag || ( gate[0] == vertex_indexs[0] && gate[1] == vertex_indexs[1] );
            flag = flag || ( gate[0] == vertex_indexs[1] && gate[1] == vertex_indexs[0] );

            if( flag )
              gates.push( i );
          }

        if( !flag ){
          gates.push( this.array.gate.length );
          this.array.gate.push( vertex_indexs );
        }
      }

      //console.log( cell.const.index, gates )
      cell.array.gate = gates;
    }

    for( let i = 0; i < this.array.cell.length - 1; i++ )
      for( let j = i + 1; j < this.array.cell.length; j++ ){
          let gate_index = this.check_joint_gate( [
            this.array.cell[i],
            this.array.cell[j]
          ] );

          if( gate_index != -1 ){
            this.array.cell[i].data.all_neighbours[gate_index] = j;
            this.array.cell[j].data.all_neighbours[gate_index] = i;
          }
        }
  }

  init_paint(){
    let colors = this.data.map.geometry.attributes.color.array;
    const color = new THREE.Color();

    for( let j = 0; j < this.array.cell.length; j++ )
      if( this.array.cell[j].flag.in_cirlce  )
        for( let i = j * 36; i < ( j + 1 ) * 36; i += 9 ){
        color.setHSL( 0.15, 1, 0.5 ); //j / this.array.cell.length

        colors[ i ] = color.r;
        colors[ i + 1 ] = color.g;
        colors[ i + 2 ] = color.b;

        colors[ i + 3 ] = color.r;
        colors[ i + 4 ] = color.g;
        colors[ i + 5 ] = color.b;

        colors[ i + 6 ] = color.r;
        colors[ i + 7 ] = color.g;
        colors[ i + 8 ] = color.b;
      }
  }

  set_cell( first, vertex_index ){
    //
    const a = this.const.a * CONST_A;
    let vector = new THREE.Vector3( WORKSPACE.x * -1, WORKSPACE.y * 1 );
    if( this.array.vertex.length != 0 )
      vector = this.array.vertex[vertex_index].clone();

    let dots = [];
    dots.push( vector.clone() );

    let center = vector.clone();
    let shift = 5;
    center.x -= Math.sin( Math.PI * 2 / this.const.n * (  first + shift ) ) * a;
    center.y -= Math.cos( Math.PI * 2 / this.const.n * (  first + shift ) ) * a;

    for( let i = first + 1; i < first + this.const.n + 1; i++ ){
      let ii = i % this.const.n;

      let vec = new THREE.Vector3(
        Math.sin( Math.PI * 2 / this.const.n * (  ii + shift ) ) * a,
        Math.cos( Math.PI * 2 / this.const.n * (  ii + shift ) ) * a,
        0 );
      vec.add( center );
      dots.push( vec );
    }

    let vertex_indexs = [];

    for( let i = 0; i < dots.length; i++ ){
      let min_d = a / 2;
      let vertex_index = null;

      for( let j = 0; j < this.array.vertex.length; j++ ){
        let d = dots[i].distanceTo( this.array.vertex[j] );

        if( d < min_d ){
          vertex_index = j;
          break;
        }
      }

      if( vertex_index == null ){
        this.array.vertex.push( dots[i] );
        vertex_indexs.push( this.array.vertex.length - 1 );
      }
      else
        vertex_indexs.push( vertex_index );
    }

    this.array.cell.push( new cell( this.var.index.cell, vertex_indexs, this ) );
    this.var.index.cell++;
  }

  check_joint_gate( cells ){
    let gate_index = -1;

    for( let i = 0; i < cells[0].array.gate.length; i++ )
      if( gate_index == -1 ){
        let index = cells[1].array.gate.indexOf( cells[0].array.gate[i] )

        if( index != -1 )
          gate_index = cells[1].array.gate[index];
      }

    return gate_index;
  }

  check_cell_center_in_circle( cell ){
    let main_center = this.array.cell[this.var.index.center].const.center;
    let d = cell.const.center.distanceTo( main_center );
    let r = Math.min( WORKSPACE.x, WORKSPACE.y ) / 2;/*Math.min(
      Math.abs( main_center.x - WORKSPACE.x ),
      Math.abs( -main_center.x + WORKSPACE.x ),
      Math.abs( main_center.y  - WORKSPACE.y ),
      Math.abs( -main_center.y  + WORKSPACE.y ) );*/
    cell.flag.in_workspace = cell.flag.in_workspace && ( d < r );
  }

  cells_around_center(){
    let n = Math.min( Math.floor( ( this.const.rows - 1 ) / 2 ), Math.floor( ( this.const.cols - 1 ) / 2 ) );
    let neighbours = [ this.var.index.center ];
    this.array.cell[this.var.index.center].flag.in_cirlce = true;

    for( let i = 0; i < n; i++ ){
      let new_neighbours = [];

      for( let old_neighbour of neighbours ){
        let all_neighbours = this.array.cell[old_neighbour].data.all_neighbours;
        let keys = Object.keys( all_neighbours );

        for( let key of keys )
          if( !this.array.cell[all_neighbours[key]].flag.in_cirlce )
            new_neighbours.push( all_neighbours[key] );
      }

      for( let new_neighbour of new_neighbours )
        this.array.cell[new_neighbour].flag.in_cirlce = true;

      neighbours = new_neighbours;
    }

    for( let cells of this.array.cell ){
      let keys = Object.keys( cells.data.all_neighbours );

      for( let key of keys )
        if( this.array.cell[cells.data.all_neighbours[key]].flag.in_cirlce )
          cells.data.neighbours[key] = cells.data.all_neighbours[key];
    }
  }

  render(){
    //


    this.data.renderer.render( this.data.scene, this.data.camera );
  }
}
