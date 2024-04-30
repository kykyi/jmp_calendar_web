// app/javascript/controllers/form_updates_controller.js
import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  updateForm(event) {
    let uni = document.querySelector('#uni_select').value;
    let year = document.querySelector('#year_select')?.value;
    let spreadsheet = document.querySelector('#spreadsheet_select')?.value;
    let pbl = document.querySelector('#pbl_select')?.value;
    let clin = document.querySelector('#clin_select')?.value;
    let complete = document.querySelector('#complete')?.value;

    const frameId = event.target.dataset.frameId;

    let url = `/calendars/update_form?frame_id=${frameId}&`;

    if (!!complete) {
      url = `/calendars?`;
    }

    // Build up the query params
    if (uni) {
      url += `uni=${encodeURIComponent(uni)}&`;
      if (year) {
        url += `year=${encodeURIComponent(year)}&`;
        if (spreadsheet) {
          url += `spreadsheet=${encodeURIComponent(spreadsheet)}&`;
          if (pbl) {
            url += `pbl=${encodeURIComponent(pbl)}&`;
            if (clin) {
              url += `clin=${encodeURIComponent(clin)}`;
            }
          }
        }
      }

      if (!!complete) {
        debugger
          // CSRF Token
        const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

        // Fetch request
        fetch(url, {
          method: 'POST',
          headers: {
            'X-CSRF-Token': csrfToken, // Include CSRF token in the request header
            'Accept': 'text/html' // Expect HTML response (adjust if your server responds with JSON)
          },
          body: {
            uni: uni,
            year: year,
            spreadsheet: spreadsheet,
            pbl: pbl,
            clin: clin
          }
        }).then(response => {
          if (response.ok) {
            return response.text(); // or response.json() if your server responds with JSON
          } else {
            throw new Error('Network response was not ok.');
          }
        }).then(html => {
          // Handle the HTML or JSON response here
          // For example, you might want to replace part of the page with new HTML
          // Or redirect the user
          console.log("Form submitted successfully!");
        }).catch(error => {
          console.error('There was a problem with the fetch operation:', error);
        });
      } else {
        Turbo.visit(url, { frame: frameId });
      }

    }
  }
}
