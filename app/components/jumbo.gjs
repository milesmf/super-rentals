import LinkTo from '@ember/routing/link-to';

<template>
  <div class="jumbo">
    <div class="right tomster"></div>
    {{yield}}
  </div>
  <LinkTo @route="index" class="button">Home</LinkTo>
</template>
  