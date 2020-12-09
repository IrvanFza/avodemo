import EditField from '@/components/EditField.vue'
import IndexField from '@/components/IndexField.vue'
import ShowField from '@/components/ShowField.vue'

import '@/stylesheets/field.css'

if (window.Avo) {
  window.Avo.initializing((Vue) => {
    Vue.component('edit-title-field', EditField)
    Vue.component('index-title-field', IndexField)
    Vue.component('show-title-field', ShowField)
  })
}
