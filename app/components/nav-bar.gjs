import { LinkTo } from '@ember/routing'

<template>
<nav class="menu">
  <LinkTo @route="index" class="menu-index">
		<div class="tomster"></div>
    <h1>SuperNiceRentals</h1>
  </LinkTo>
  <div class="links">
    <LinkTo @route="about" class="menu-about">
      About
    </LinkTo>
    <LinkTo @route="contact" class="menu-contact">
      Contact
    </LinkTo>
  </div>
</nav>
</template>