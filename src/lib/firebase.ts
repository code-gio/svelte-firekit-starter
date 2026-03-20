import { initFirekit } from 'svelte-firekit';

export const firebaseConfig = {
    apiKey: "AIzaSyCHouvMDQqXvQrUA-iwj5JKyYmQEfKrZps",
    authDomain: "mindhyv-78c41.firebaseapp.com",
    databaseURL: "https://mindhyv-78c41-default-rtdb.firebaseio.com",
    projectId: "mindhyv-78c41",
    storageBucket: "mindhyv-78c41.appspot.com",
    messagingSenderId: "611329425828",
    appId: "1:611329425828:web:2bdf29ee91e6ed28dfc131",
    measurementId: "G-NGQD0B3KH4"// required for Realtime Database
};

initFirekit(firebaseConfig);