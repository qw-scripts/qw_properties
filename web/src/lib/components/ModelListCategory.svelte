<script lang="ts">
  export let name: string;
  export let selected: boolean = false;
</script>

<button
  class="{selected
    ? 'bg-zinc-700'
    : 'bg-zinc-800 hover:bg-zinc-700'} p-2 max-w-9 flex items-center justify-center shadow-lg transition-all duration-200 rounded-r-md"
>
  <span class="text-zinc-100 text-sm font-semibold vertical-text">{name}</span>
</button>

<style>
  .vertical-text {
    writing-mode: vertical-rl;
    transform: rotate(360deg);
  }
</style>
