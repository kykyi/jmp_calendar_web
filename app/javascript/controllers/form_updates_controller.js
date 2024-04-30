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

    const frameId = event.target.dataset.frameId;
    let url = `/calendars/update_form?frame_id=${frameId}&`;

    console.log(uni)


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
      Turbo.visit(url, { frame: frameId });
    }
  }
}
