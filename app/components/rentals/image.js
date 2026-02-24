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
 		{{#if this.isLarge}}
	  		<button type="button" class="image large" {{on "click" this.toggleSize}}>
    			<img ...attributes>
    			<small>View Smaller</small>
  			</button>
 		{{else}}
  			<button type="button" class="image" {{on "click" this.toggleSize}}>
    			<img ...attributes>
    			<small>View Larger</small>
  			</button>
 		{{/if}}
	</template>
}
