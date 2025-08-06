// Only run if it's a 404 and not already on 404.html
if (window.location.pathname !== '/404.html') {
  fetch(window.location.href, { method: 'HEAD' }).then(response => {
    if (!response.ok) {
      window.location.href = '/404.html';
    }
  });
}
