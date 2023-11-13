<template>
  <div v-if="contributors.length">
    <h2>account ------> amount -----> datetime</h2>
    <div v-for="item in contributors" :key="item.id">
      account: {{ item["account"] }} ---> amount: {{ item["amount"] }} -->

      {{ format(item["datetime"] * 1000, "dd/MM/yyyy hh:mm a") }}
    </div>
  </div>

  <div v-else>
    <h1>No contributor found.</h1>
  </div>
</template>

<script setup>
const contributors = ref([]);
import { format } from "date-fns";
// const { data } = await useMyFetch("/api/contributors");
// contributors = data.value;
async function getContributors() {
  const { data } = await useMyFetch("/api/contributors");
  contributors.value = data.value;
}

onMounted(getContributors);
</script>
