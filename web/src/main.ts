import "./app.css";
import App from "./App.svelte";
import { isEnvBrowser } from "./lib/debug";

const app = new App({
  target: document.getElementById("app")!,
});

if (isEnvBrowser()) {
  const root = document.getElementById("app");

  // https://i.imgur.com/iPTAdYV.png - Night time img
  root!.style.backgroundImage = 'url("https://i.imgur.com/3pzRj9n.png")';
  root!.style.backgroundSize = "cover";
  root!.style.backgroundRepeat = "no-repeat";
  root!.style.backgroundPosition = "center";
}

export default app;
