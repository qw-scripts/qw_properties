<script lang="ts">
  import { onMount } from "svelte";
  import "./app.css";
  import Controls from "./lib/components/Controls.svelte";
  import ModelList from "./lib/components/ModelList.svelte";
  import { debugData, isEnvBrowser } from "./lib/debug";
  import { fetchNui } from "./lib/fetcher";
  import { useNuiEvent } from "./lib/nuiEvent";
  import { modelData } from "./lib/stores/model";
  import { get } from "svelte/store";

  let show = false;

  useNuiEvent("toggleMenu", (data: boolean) => {
    show = data;
  });

  useNuiEvent("controlModel", (data: ModelData) => {
    modelData.set(data);
  });

  const handleClose = () => {
    if (!show || get(modelData).entity !== 0) return;
    show = false;
    if (isEnvBrowser()) return;
    fetchNui("closeMenu");
  };

  onMount(() => {
    const keyHandler = (e: KeyboardEvent) => {
      if (["Escape"].includes(e.code)) handleClose();
    };

    window.addEventListener("keydown", keyHandler);

    return () => window.removeEventListener("keydown", keyHandler);
  });

  debugData<any>([
    {
      action: "toggleMenu",
      data: true,
    },
    {
      action: "controlModel",
      data: {
        direction: "translate",
        entity: 999,
        model: "prop_weed_01",
      },
    },
  ]);
</script>

<main class="w-screen h-screen overflow-hidden bg-transparent">
  <div class="flex items-center justify-between p-3 h-full w-full">
    <ModelList {show} />
    <Controls />
  </div>
</main>
