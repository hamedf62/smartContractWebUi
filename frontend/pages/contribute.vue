<template>
  <div>
    <el-form :model="form" style="max-width: 460px">
      <el-form-item label="Account:">
        <el-select
          v-model="form.account"
          placeholder="please select an account"
        >
          <div v-for="item in accounts" :key="item">
            <!-- {{ item.name }} -->
            <el-option :label="item" :value="item" />
          </div>
        </el-select>
      </el-form-item>
      <el-form-item label="Amount in Etherium">
        <el-input v-model="form.amount" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="onSubmit()">Submit</el-button>
        <el-button @click="resetForm()">Reset</el-button>
      </el-form-item>
    </el-form>
    <!-- <div v-for="(value, key) in result1" :key="key">{{ key }}: {{ value }}</div> -->
    <!-- <div>{{ result1 }}</div> -->

    <div v-if="result1" v-for="(value, key) in JSON.parse(result1)" :key="key">
      {{ key }}: {{ value }}
    </div>
  </div>
</template>

<!-- <script lang="ts" setup>
const emit = defineEmits(["fetchData"]);
</script> -->

<script lang="ts">
import { defineComponent, reactive, ref, defineEmits } from "vue";
import type { Action } from "element-plus";
// const emit = defineEmits(["fetchData"]);
export default defineComponent({
  // emit: "fetchData",

  async setup() {
    const form = reactive({
      amount: "",
      account: "",
    });
    const { $event } = useNuxtApp();
    // const emit = defineEmits(["fetchData"]);

    const result1 = ref();
    // const fetchAccounts = async () => {
    //   accounts.value = await useMyFetch("/api/accounts");
    // };
    const { data: accounts } = await useMyFetch("/api/accounts");
    // onMounted(async () => {
    //   const res = await useMyFetch("/api/accounts");
    //   accounts.value = res.data;
    // });

    const onSubmit = async () => {
      // submit logic
      const { data, pending, error, refresh } = await useMyFetch(
        "/api/contribute",
        {
          method: "POST",
          body: form,
        }
      );
      // console.log(result);
      // return result;
      $event("reget_contract_status");
      result1.value = data.value;
      // ElMessageBox.alert(
      //   "Hoora you deposited: " + form.amount + " Ether.",
      //   "successfull contribution",
      //   {
      //     // if you want to disable its autofocus
      //     // autofocus: false,
      //     confirmButtonText: "OK",
      //     callback: (action: Action) => {
      //       ElMessage({
      //         type: "info",
      //         message: `action: ${action}`,
      //       });
      //     },
      //   }
      // );
      ElMessage({
        message: "Hoora you deposited: " + form.amount + " Ether.",
        type: "success",
      });
    };

    const resetForm = () => {
      // $event("reget_contract_status");
    };

    return {
      form,
      accounts,
      onSubmit,
      resetForm,
      result1,
    };
  },
});
</script>
