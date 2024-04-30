// app/javascript/controllers/form_updates_controller.js
import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  updateForm(event) {
    const uni = document.querySelector('#uni_select').value;
    const year = document.querySelector('#year_select')?.value;
    const spreadsheet = document.querySelector('#spreadsheet_select')?.value;
    const pbl = document.querySelector('#pbl_select')?.value;
    const clin = document.querySelector('#clin_select')?.value;

    const frameId = event.target.dataset.frameId;
    let url = `/calendars/update_form?frame_id=${frameId}&`;

    console.log(uni, year)

    // Build up the query params
    if (uni) {
      url += `uni=${uni}&`;
      if (year) {
        url += `year=${year}&`;
        if (spreadsheet) {
          url += `spreadsheet=${spreadsheet}&`;
          if (pbl) {
            url += `pbl=${pbl}&`;
            if (clin) {
              url += `clin=${clin}`;
            }
          }
        }
      }
      Turbo.visit(url, { frame: frameId });
    }
  }
}
