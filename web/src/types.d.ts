interface Position {
  x: number;
  y: number;
  z: number;
}

interface Quaternion {
  x: number;
  y: number;
  z: number;
  w: number;
}

type ModelerMode = "translate" | "rotate";

interface ModelData {
  entity: number;
  model: string;
  direction: ModelerMode;
}
