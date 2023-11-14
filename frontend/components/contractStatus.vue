<template>
  <div v-for="(value, key) in contract_status" :key="key">
    {{ key }}: {{ value }}
  </div>
  <!-- <div>111</div> -->
  <!-- <button @click="hamed">click</button> -->
</template>

<!-- <script setup>
const contractStatus = ref([]);
const { data, pending, refresh } = await useMyFetch("/api/contract_status");
contractStatus.value = data.value;

async function hamed() {
  console.log("hamedam..");
  refresh();
}
// hamed();
</script> -->

<!-- <script>
import { ref } from "vue";

export default {
  setup() {
    // const { data: contract_status } = await useMyFetch("/api/contract_status");
    const { $listen } = useNuxtApp();
    const contract_status = ref(null);

    const getData = async () => {
      const { data } = await useMyFetch("/api/contract_status");
      contract_status.value = data.value;
    };

    $listen("reget_contract_status", () => {
      console.log("A user was registered!");
      getData();
    });

    return {
      contract_status,
    };
  },
};
</script> -->

<script setup>
// const { data: contract_status } = await useMyFetch("/api/contract_status");
const { $listen } = useNuxtApp();
// const contract_status = ref();

const {
  data: contract_status,
  pending,
  error,
  refresh,
} = await useMyFetch("/api/contract_status");

$listen("reget_contract_status", () => {
  console.log("A user was registered!");
  refresh();
});
// contract_status.value = data.value;
// getData();
// onBeforeMount(()=>{getData();},
</script>
