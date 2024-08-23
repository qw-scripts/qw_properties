<script lang="ts">
  import {
    cancelEdit,
    modelData,
    resetPosition,
    resetRotation,
    saveFurniture,
    snapToGround,
  } from "../stores/model";
  import { fly } from "svelte/transition";
</script>

{#if $modelData.entity !== 0}
  <div
    class="flex flex-col gap-3 h-fit w-1/6 select-none bg-zinc-900 shadow-lg p-2 rounded-md mt-10"
    in:fly={{ x: 300, duration: 300, delay: 0 }}
    out:fly={{ x: 300, duration: 300, delay: 0 }}
  >
    <div class="flex items-center gap-2">
      <button
        class="bg-zinc-800 p-2 rounded-md min-w-12 text-center shadow-lg hover:bg-zinc-700 transition-all duration-200 flex-1"
        on:click={resetRotation}
      >
        <span class="text-zinc-100 text-sm font-semibold">
          Reset Rotation
        </span>
      </button>
      <button
        class="bg-zinc-800 p-2 rounded-md min-w-12 text-center shadow-lg hover:bg-zinc-700 transition-all duration-200 flex-1"
        on:click={resetPosition}
      >
        <span class="text-zinc-100 text-sm font-semibold">
          Reset Position
        </span>
      </button>
    </div>
    <button
      class="bg-zinc-800 p-2 rounded-md min-w-12 text-center shadow-lg hover:bg-zinc-700 transition-all duration-200"
      on:click={snapToGround}
    >
      <span class="text-zinc-100 text-sm font-semibold"> Snap to ground </span>
    </button>
    <div class="flex items-center gap-2">
      <button
        class="bg-zinc-800 p-2 rounded-md min-w-12 text-center shadow-lg hover:bg-zinc-700 transition-all duration-200 flex items-center justify-center gap-2 flex-1"
        on:click={cancelEdit}
      >
        <i class="fas fa-cancel text-zinc-100"></i>
        <span class="text-zinc-100 text-sm font-semibold"> Cancel </span>
      </button>
      <button
        class="bg-zinc-800 p-2 rounded-md min-w-12 text-center shadow-lg hover:bg-zinc-700 transition-all duration-200 flex items-center justify-center gap-2 flex-1"
        on:click={saveFurniture}
      >
        <i class="fas fa-save text-zinc-100"></i>
        <span class="text-zinc-100 text-sm font-semibold">
          Save Furniture
        </span>
      </button>
    </div>
  </div>
{/if}
