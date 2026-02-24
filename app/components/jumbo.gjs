import { LinkTo } from '@ember/routing';

<template>
  <div class="jumbo">
    {{yield}}
		<LinkTo @route="index" class="button">Home</LinkTo>
  </div>
</template>
  