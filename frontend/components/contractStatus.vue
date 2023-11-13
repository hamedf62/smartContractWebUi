<template>
  <div v-for="(value, key) in contract_status" :key="key">
    {{ key }}: {{ value }}
  </div>
</template>

<script setup>
// const { data: contract_status } = await useMyFetch("/api/contract_status");
const { $listen } = useNuxtApp();
const contract_status = ref();

const getData = async () => {
  const { data } = await useMyFetch("/api/contract_status");
  contract_status.value = data.value;
};

// on
// onMounted(() => {
//   // document.addEventListener('fetchData', fetchData)
//   // getData();
//   console.log(contract_status.value);
// });

$listen("reget_contract_status", () => {
  console.log("A user was registered!");
  getData();
});
getData();
</script>
