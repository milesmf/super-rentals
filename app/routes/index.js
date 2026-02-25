import Route from '@ember/routing/route';
import { transformRental } from "../utils/rental';

export default class IndexRoute extends Route {
	async model {
		let response = await fetch('/api/rentals.json');
		let { data } = await response.jsonO;
		return data.map(transformRental);
	}
}