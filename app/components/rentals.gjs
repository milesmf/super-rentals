import { LinkTo } from '@ember/routing';
import RentalsImage from './rentals/image';
import Map from './map';

<template>
<article class="rental">
	<RentalsImage
	  src={{@rental.image}}
    alt={{@rental.description}}
	>
  </RentalsImage>
  <div class="details">
    <LinkTo @route="rental" @model={{@route}}>
			<h3>{{@rental.title}}</h3>
		</LinkTo>
    <div class="detail owner">
      <span>Owner:</span> {{@rental.owner}}
    </div>
    <div class="detail type">
      <span>Type:</span> {{@rental.type}}
    </div>
    <div class="detail location">
      <span>Location:</span> {{@rental.city}}
    </div>
    <div class="detail bedrooms">
      <span>Number of bedrooms:</span> {{@rental.bedrooms}}
    </div>
  </div>
	<Map
  	@lat="{{@rental.location.lat}}"
  	@lng="{{@rental.location.lng}}"
  	@zoom="14"
  	@width="150"
  	@height="150"
  	alt="Map of {{@rental.title}}"
	/>
</article>
</template>
