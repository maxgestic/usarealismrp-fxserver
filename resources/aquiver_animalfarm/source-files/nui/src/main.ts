import { createPinia } from 'pinia';
import { createApp } from 'vue';
import App from './views/App';

import 'animate.css';
import './style/global.scss';

createApp(App).use(createPinia()).mount('#app');