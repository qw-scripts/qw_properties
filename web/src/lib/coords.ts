export function convertToThree(pos: Position): Position {
  return {
    x: pos.x,
    y: pos.z,
    z: pos.y,
  };
}

export function convertToGTA(pos: Position): Position {
  return {
    x: pos.x,
    y: -pos.z,
    z: pos.y,
  };
}
