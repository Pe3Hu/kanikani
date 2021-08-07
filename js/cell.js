class cell{
  constructor( index, vertexs, board ){
    this.const = {
      index: index,
      center: null
    };
    this.flag = {
      in_workspace: true,
      in_cirlce: false,
      free: true
    };
    this.var = {
    };
    this.array = {
      vertex: vertexs,
      gate: []
    };
    this.data = {
      hue: null,
      board: board,
      neighbours: {},
      all_neighbours: {}
    };

    this.set_center();
  }

  set_center(){
    let x = 0;
    let y = 0;

    for( let index of this.array.vertex ){
      let vertex = this.data.board.array.vertex[index];
      x += vertex.x / this.array.vertex.length;
      y += vertex.y / this.array.vertex.length;
    };

    this.const.center = new THREE.Vector3(
      x,
      y,
      0
    );
  }
}
