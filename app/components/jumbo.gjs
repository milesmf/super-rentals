import { LinkTo } from '@ember/routing';

<template>
  <div class="jumbo">
    <div class="right tomster"></div>
    {{yield}}
		<div style="margin-top: 12px">
			<LinkTo @route="index" class="button">Home</LinkTo>
		</div>
  </div>
</template>
  