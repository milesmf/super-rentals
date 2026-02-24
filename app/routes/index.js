import Route from '@ember/routing/route';

export default class IndexRoute extends Route {
	async model() {
    	let response = await fetch('/api/rentals.json');
    	let parsed = await response.json();
    	return parsed;
    }
}