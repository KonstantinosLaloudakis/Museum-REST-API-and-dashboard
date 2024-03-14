
let activeGTag = null; // To keep track of the currently active <g> tag

function showPopover(gTag, ratings) {
    if (activeGTag === gTag) {
        hidePopover();
        return;
    }
    activeGTag = gTag;
    const gRect = gTag.getBoundingClientRect();
    const svgContainer = document.querySelector('.container');
    const svgContainerRect = svgContainer.getBoundingClientRect();
	const cellId = gTag.id; // Assuming cellId is stored in the gTag.id property

	// Find the data for the specific cell (cellId) in the ratings array
    const cellData = ratings.find(data => data.cell === cellId);

	if (cellData) {
		const averageRating = parseFloat(cellData.rating); // Parse as a float
        const numberOfRatings = cellData.ratings_count;

        if (!isNaN(averageRating)) { // Check if it's a valid number
            const starRating = generateStarRating(averageRating);

            popover.innerHTML = `
                <div class="popover-content">
                    ${starRating}
                    <div class="rating-info">
                        <span class="average-rating">${averageRating.toFixed(1)}</span>
                        <span class="total-ratings">(${numberOfRatings} Ratings)</span>
                    </div>
                </div>
            `;
            } else {
            // Handle the case where averageRating is not a valid number
            console.error('Invalid averageRating value:', cellData.avgRating);
        }
	}
	else {
        // Handle the case where cellData is not found in the ratings list
        popover.innerHTML = `
            <div class="popover-content">
                ${generateStarRating(0)}
                <div class="rating-info">
                    <span class="average-rating">0.0</span>
                    <span class="total-ratings">(0 Ratings)</span>
                </div>
            </div>
        `;
    }
	popover.style.display = 'block';
	popover.style.top = (gRect.top - svgContainerRect.top - popover.offsetHeight) + 'px';
	popover.style.left = (gRect.left - svgContainerRect.left + (gRect.width - popover.offsetWidth) / 2) + 'px';

}

function hidePopover() {
    activeGTag = null;
    popover.style.display = 'none';
}

// Function to generate star rating HTML
function generateStarRating(averageRating) {
    const maxRating = 5; // Assuming a maximum rating of 5 stars
    const starPercentage = (averageRating / maxRating) * 100;
    const starWidth = `${Math.round(starPercentage / 10) * 10}%`;

    // Create an array to hold individual stars
    const stars = [];
    
    // Loop to create each star
    for (let i = 0; i < maxRating; i++) {
        const starClass = i < Math.floor(averageRating) ? 'filled' : 'unfilled';
        stars.push(`<span class="star ${starClass}"></span>`);
    }

    return `
        <div class="star-rating">
            ${stars.join('')}
        </div>
    `;
}





  
// Add click event listener to each <g> tag
/*gTags.forEach((gTag) => {
  gTag.addEventListener('click', (event) => {
    const id = gTag.id;
	const path = gTag.getElementsByTagName('path')[0];
      var popover = document.getElementById('popover');
      popover.innerHTML = 'ID: ' + id;
      popover.style.display = 'block';
      popover.style.top = (path.getBoundingClientRect().top - path.getBoundingClientRect().height - popover.offsetHeight) + 'px';
      popover.style.left = path.getBoundingClientRect().left + 'px';
    
  });
});*/


