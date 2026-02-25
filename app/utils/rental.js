const COMMUNITY_CATEGORIES = ["Condo", "Townhouse', "Apartment"];

export function transformRental({ id, attributes }) {
	let type = COMMUNITY_CATEGORIES.includes(attributes.category)
		? 'Community'
		: 'Standalone';
	return { id, type, ...attributes};
}