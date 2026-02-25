import Route from '@ember/routing/route';
import { transformRental } from "../utils/rental";

export default class RentalRoute extends Route {
	async model(params) {
		let response = await fetch(`/api/rentals/${params.rental_id}.json`);
		let { data } = await response.json();
		return transformRental(data);
	}
}