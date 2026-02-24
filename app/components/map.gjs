import Component from '@glimmer/component';
import ENV from 'super-rentals/config/environment';

const MAPBOX_API = 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static';

export default class MapComponent extends Component {
  get token() {
    return encodeURIComponent(ENV.MAPBOX_ACCESS_TOKEN);
  }

	get mapSrc() {
		const { lng: longitude, lat: latitude, zoom, width, height } = this.args;

		const coordinates = `${longitude},${latitude},${zoom}`;
		const dimensions = `${width}x${height}`;
		const token = `access_token=${this.token}`;

		const src = `${MAPBOX_API}/${coordinates}/${dimensions}@2x?${token}`;

		console.log('src:', src);

		return src;
	}

<template>
  <div class="map">
    <img
      alt="Map image at coordinates {{@lat}},{{@long}}"
      ...attributes
      src="{{this.mapSrc}}"
      width={{@width}}
      height={{@height}}
    />
  </div>
</template>
}