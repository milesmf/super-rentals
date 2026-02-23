import { pageTitle } from 'ember-page-title';
import NavBar from '../components/nav-bar';

<template>
  {{pageTitle "SuperRentals"}}
  <NavBar />

  {{outlet}}
</template>
