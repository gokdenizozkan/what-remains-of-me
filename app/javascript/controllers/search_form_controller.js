import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-form"
export default class extends Controller {
  static targets = ["searchBar"]

  connect() {
    this.timeout = null;
    this.searchBar = document.getElementById('search-bar');
    this.loadingIndicator = document.getElementById('loading-indicator');
    this.form = this.searchBar.closest('form');
    this.form.addEventListener('turbo:submit-start', this.startLoading.bind(this));
    this.form.addEventListener('turbo:submit-end', this.endLoading.bind(this));
  }

  search() {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this.form.requestSubmit();
    }, 200);
  }

  startLoading() {
    this.loadingIndicator.classList.remove('is-hidden');
  }

  endLoading() {
    this.loadingIndicator.classList.add('is-hidden');
  }
}
