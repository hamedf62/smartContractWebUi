<template>
  <el-menu
    :default-active="activeIndex"
    class="el-menu-demo"
    mode="horizontal"
    :ellipsis="false"
    @select="handleSelect"
  >
    <el-menu-item index="0">
      <img style="width: 100px" src="/images/images.jpg" alt="Element logo" />
    </el-menu-item>
    <div class="flex-grow" />

    <el-row class="mb-4">
      <NuxtLink to="/">
        <el-button type="primary">Home</el-button>
      </NuxtLink>
      <NuxtLink to="/contribute"
        ><el-button type="primary">New Contribute</el-button>
      </NuxtLink>
      <NuxtLink to="/contributors">
        <el-button type="success">contributors</el-button>
      </NuxtLink>
      <NuxtLink>
        <el-button type="info">Withdraw to Owner</el-button>
      </NuxtLink>
      <NuxtLink>
        <el-button type="warning">Refund Contributors</el-button>
      </NuxtLink>
      <NuxtLink>
        <el-button type="danger">Complete Project</el-button>
      </NuxtLink>
    </el-row>
  </el-menu>
</template>

<script lang="ts" setup>
import { ref } from "vue";

const activeIndex = ref("1");
const handleSelect = (key: string, keyPath: string[]) => {
  console.log(key, keyPath);
};
// export default {
//   // methods: {
//   //   navigateToHome() {
//   //     this.$router.push("/");
//   //   },
//   //   navigateToContributors() {
//   //     this.$router.push("/contributors");
//   //   },
//   // },
// };
</script>

<style>
.flex-grow {
  flex-grow: 1;
}
</style>
