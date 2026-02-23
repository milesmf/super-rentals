import { LinkTo } from '@ember/routing';

<template>
  <div class="jumbo">
    <div class="right tomster"></div>
    {{yield}}
		<div>
			<LinkTo @route="index" class="button">Home</LinkTo>
		</div>
  </div>
</template>
  