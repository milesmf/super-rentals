import { LinkTo } from '@ember/routing';

<template>
  <div class="jumbo">
		<LinkTo @route="index" class="button">Home</LinkTo>
    {{yield}}
  </div>
</template>
  