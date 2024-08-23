<script lang="ts">
  export let model: string;
</script>

<div
  class="flex items-center justify-between w-full p-3 bg-zinc-800 text-zinc-100 rounded-md shadow-lg"
>
  <span class="text-sm font-semibold">
    {model}
  </span>
  <button
    class="flex items-center justify-center w-8 h-8 bg-zinc-700 hover:bg-zinc-600 text-zinc-100 rounded-md transition-all duration-200"
  >
    <i class="fa-solid fa-eye"></i>
  </button>
</div>
