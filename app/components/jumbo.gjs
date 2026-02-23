import { LinkTo } from '@ember/routing';

<template>
  <div class="jumbo">
    <div class="right tomster"></div>
    {{yield}}
		<LinkTo @route="index" class="button">Home</LinkTo>
  </div>
</template>
  