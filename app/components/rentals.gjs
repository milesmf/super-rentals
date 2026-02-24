import RentalsImage from './rentals/image';
import Map from './map';

<template>
<article class="rental">
	<RentalsImage
	  src="https://upload.wikimedia.org/wikipedia/commons/c/cb/Crane_estate_(5).jpg"
    alt="A picture of Grand Old Mansion"
	>
  </RentalsImage>
  <div class="details">
    <h3>Grand Old Mansion</h3>
    <div class="detail owner">
      <span>Owner:</span> Veruca Salt
    </div>
    <div class="detail type">
      <span>Type:</span> Standalone
    </div>
    <div class="detail location">
      <span>Location:</span> San Francisco
    </div>
    <div class="detail bedrooms">
      <span>Number of bedrooms:</span> 15
    </div>
  </div>
	<Map
  	@lat="41.9397"
  	@lng="-87.7286"
  	@zoom="14"
  	@width="150"
  	@height="150"
  	alt="Map of 4055 W Melrose St, Chicago"
	/>
</article>
</template>
