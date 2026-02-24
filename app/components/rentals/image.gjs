import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';  

export default class RentalsImage extends Component {
	@tracked isLarge = false;

	@action toggleSize() {
    	this.isLarge = !this.isLarge;
	}

	<template>
		<button type="button" class="image {{if this.isLarger "large"}}" {{on "click" this.toggleSize}}>
    	<img ...attributes>
    	<small>View {{if this.isLarger "Smaller" "Larger"}}</small>
  	</button>
	</template>
}
