import { writable } from "svelte/store";
import { fetchNui } from "../fetcher";
import { isEnvBrowser } from "../debug";

const defaultState: ModelData = {
  model: "",
  direction: "translate",
  entity: 0,
};

export const modelData = writable<ModelData>(defaultState);

export function changeDirection(direction: ModelData["direction"]) {
  modelData.update((data) => {
    if (data) {
      data.direction = direction;
    }
    return data;
  });

  !isEnvBrowser() && fetchNui("setDirection", direction);
}

export function setHasMouseFocus(hasFocus: boolean) {
  !isEnvBrowser() && fetchNui("setUIHasMouse", hasFocus);
}

export function resetRotation() {
  !isEnvBrowser() && fetchNui("resetRotation");
}

export function resetPosition() {
  !isEnvBrowser() && fetchNui("resetPosition");
}

export function snapToGround() {
  !isEnvBrowser() && fetchNui("snapToGround");
}

export function cancelEdit() {
  modelData.set(defaultState);
  !isEnvBrowser() && fetchNui("cancelEdit");
}

export function saveFurniture() {
  modelData.set(defaultState);
  !isEnvBrowser() && fetchNui("saveCurrentEdit");
}
