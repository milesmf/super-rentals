import Component from '@glimmer/component';
import ENV from 'super-rentals/config/environment';

export default class MapComponent extends Component {
  get token() {
    return encodeURIComponent(ENV.MAPBOX_ACCESS_TOKEN);
  }

<template>
  <div class="map">
    <img
      alt="Map image at coordinates {{@lat}},{{@lng}}"
      ...attributes
      src="https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/{{@lng}},{{@lat}},{{@zoom}}/{{@width}}x{{@height}}?access_token={{this.token}}"
      width={{@width}}
      height={{@height}}
    />
  </div>
</template>
}