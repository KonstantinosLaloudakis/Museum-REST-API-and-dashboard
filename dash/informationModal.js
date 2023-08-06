
let activeGTag = null; // To keep track of the currently active <g> tag

function showPopover(event) {
	const gTag = event.currentTarget; // Use currentTarget to get the <g> element clicked
		if (activeGTag === gTag) {
			hidePopover();
			return;
		}
		activeGTag = gTag;
		const id = gTag.id;
		const gRect = gTag.getBoundingClientRect();
		const svgContainer = document.querySelector('.container');
		const svgContainerRect = svgContainer.getBoundingClientRect();
		
	
		popover.innerHTML = 'ID: ' + id;
		popover.style.display = 'block';
		popover.style.top = (gRect.top - svgContainerRect.top - popover.offsetHeight) + 'px';
		popover.style.left = (gRect.left - svgContainerRect.left + (gRect.width - popover.offsetWidth) / 2) + 'px';
}

function hidePopover() {
	activeGTag = null;
	popover.style.display = 'none';
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


