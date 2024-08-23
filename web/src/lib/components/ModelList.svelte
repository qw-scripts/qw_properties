<script lang="ts">
  import { onDestroy, onMount } from "svelte";
  import ModelListCategory from "./ModelListCategory.svelte";
  import ModelListItem from "./ModelListItem.svelte";
  import { fly } from "svelte/transition";
  import { fetchNui } from "../fetcher";

  export let show = false;
  let hasMouse = true;

  function changeMode(e: MouseEvent) {
    if (e.button == 2) {
      fetchNui("setUIHasMouse", !hasMouse);
      hasMouse = !hasMouse;
    }
  }

  onMount(() => {
    document.addEventListener("contextmenu", changeMode);
  });
  onDestroy(() => {
    hasMouse = true;
    document.removeEventListener("contextmenu", changeMode);
  });
</script>

{#if show}
  <div
    class="flex flex-col h-full w-1/5 select-none"
    in:fly={{ x: -300, duration: 300, delay: 0 }}
    out:fly={{ x: -300, duration: 300, delay: 0 }}
  >
    <div class="flex items-center gap-2 ml-3">
      <button
        class="bg-zinc-800 hover:bg-zinc-700 p-2 rounded-t-md min-w-12 text-center shadow-lg transition-all duration-200"
      >
        <span class="text-zinc-100 text-sm font-semibold">Categories</span>
      </button>
      <button
        class="bg-zinc-800 hover:bg-zinc-700 p-2 rounded-t-md min-w-12 text-center shadow-lg transition-all duration-200"
      >
        <span class="text-zinc-100 text-sm font-semibold">Owned Items</span>
      </button>
    </div>
    <div class="flex items-start h-full">
      <div
        class="w-full bg-zinc-900 h-full p-3 rounded-md flex flex-col gap-4 shadow-lg"
      >
        <input
          type="text"
          class="w-full p-2 bg-zinc-800 text-zinc-100 rounded-md border border-zinc-700 focus:outline-none focus:border-zinc-500 shadow-lg"
          placeholder="Search..."
        />
        <div
          class="flex flex-col gap-3 h-[88vh] overflow-x-hidden overflow-y-auto"
        >
          {#each Array.from({ length: 50 }, (_, i) => i) as i}
            <ModelListItem model={`Model ${i + 1}`} />
          {/each}
        </div>
      </div>
      <div class="flex flex-col gap-3 mt-16">
        <ModelListCategory name="Couches" selected />
        <ModelListCategory name="Chairs" />
        <ModelListCategory name="Storage" />
        <ModelListCategory name="Lighting" />
        <ModelListCategory name="Beds" />
        <ModelListCategory name="Electronics" />
        <ModelListCategory name="Tables" />
        <ModelListCategory name="Kitchen" />
        <ModelListCategory name="Plants" />
        <ModelListCategory name="Misc" />
      </div>
    </div>
  </div>
{/if}
