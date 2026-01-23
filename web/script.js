const translations = {
    en: {
        app_name: "Let It Be",
        hero_title: "Let It Be",
        hero_subtitle: "A minimal iOS app that delivers short, low-pressure support cards for low-energy moments.",
        cta_download: "Download for iOS",
        state_tired: "Tired",
        state_tired_desc: "Low energy? Get gentle support.",
        state_numb: "Numb",
        state_numb_desc: "Feeling empty? Reconnect slowly.",
        state_hide: "Hide",
        state_hide_desc: "Avoiding everything? That's okay.",
        state_annoyed: "Annoyed",
        state_annoyed_desc: "Too much noise? Find peace.",
        feature_stoploss: "Stop Loss",
        feature_stoploss_desc: "Simple breathing exercises and checklists to stop the downward spiral.",
        footer_copy: "© 2026 Let It Be. All rights reserved."
    },
    zh: {
        app_name: "摆烂心法",
        hero_title: "摆烂心法",
        hero_subtitle: "一个极简 iOS 应用，在低能量时提供轻量支持卡片，允许你'摆烂'，但也提供'修复'支持。",
        cta_download: "下载 iOS 版",
        state_tired: "累",
        state_tired_desc: "能量枯竭？获得轻柔支持。",
        state_numb: "麻",
        state_numb_desc: "麻木空虚？慢慢重新连接。",
        state_hide: "躲",
        state_hide_desc: "拖延逃避？没关系，允许你躲一会儿。",
        state_annoyed: "烦",
        state_annoyed_desc: "焦虑噪音？寻找片刻宁静。",
        feature_stoploss: "修复动作",
        feature_stoploss_desc: "简单的呼吸练习和极简清单，帮助你停止情绪螺旋。",
        footer_copy: "© 2026 Let It Be. 保留所有权利。"
    }
};

const screenshots = {
    en: {
        light: [
            "assets/images/en-light-1.png",
            "assets/images/en-light-2.png",
            "assets/images/en-light-3.png",
            "assets/images/en-light-4.png"
        ],
        dark: [
            "assets/images/en-dark-1.png",
            "assets/images/en-dark-2.png",
            "assets/images/en-dark-3.png",
            "assets/images/en-dark-4.png"
        ]
    },
    zh: {
        light: [
            "assets/images/cn-light-1.png",
            "assets/images/cn-light-2.png",
            "assets/images/cn-light-3.png",
            "assets/images/cn-light-4.png",
            "assets/images/cn-light-5.png"
        ],
        dark: [
            "assets/images/cn-dark-1.png",
            "assets/images/cn-dark-2.png",
            "assets/images/cn-dark-3.png",
            "assets/images/cn-dark-4.png",
            "assets/images/cn-dark-5.png"
        ]
    }
};

let currentLang = 'en';
let currentTheme = 'light';
let currentImageIndex = 0;
let slideInterval;

// DOM Elements
const heroImg = document.getElementById('hero-phone-img');
const langBtn = document.getElementById('langToggle');
const themeBtn = document.getElementById('themeToggle');

function updateContent() {
    // Update Text
    const elements = document.querySelectorAll('[data-i18n]');
    elements.forEach(element => {
        const key = element.getAttribute('data-i18n');
        if (translations[currentLang][key]) {
            element.textContent = translations[currentLang][key];
        }
    });

    // Update Button Text
    langBtn.textContent = currentLang === 'en' ? '中文' : 'English';
    document.documentElement.lang = currentLang;

    // Update Theme Attribute
    document.documentElement.setAttribute('data-theme', currentTheme);

    // Update Image immediately
    updateHeroImage();
}

function updateHeroImage() {
    // Determine which array to use
    const langKey = currentLang === 'en' ? 'en' : 'zh';
    const themeKey = currentTheme;
    const images = screenshots[langKey][themeKey];

    // Wrap index if out of bounds (useful when switching arrays of different lengths)
    if (currentImageIndex >= images.length) {
        currentImageIndex = 0;
    }

    const nextSrc = images[currentImageIndex];

    // Preload image to prevent flicker if not cached
    const tempImg = new Image();
    tempImg.onload = () => {
        heroImg.classList.remove('loaded');
        setTimeout(() => {
            heroImg.src = nextSrc;
            heroImg.onload = () => heroImg.classList.add('loaded');
        }, 150); // Slight delay for fade-out effect
    };
    tempImg.src = nextSrc;
}

function nextSlide() {
    const langKey = currentLang === 'en' ? 'en' : 'zh';
    const themeKey = currentTheme;
    const images = screenshots[langKey][themeKey];

    currentImageIndex = (currentImageIndex + 1) % images.length;
    updateHeroImage();
}

function startSlideshow() {
    if (slideInterval) clearInterval(slideInterval);
    slideInterval = setInterval(nextSlide, 3500); // Change every 3.5 seconds
}

// Event Listeners
langBtn.addEventListener('click', () => {
    currentLang = currentLang === 'en' ? 'zh' : 'en';
    currentImageIndex = 0; // Reset slideshow on change
    updateContent();
});

themeBtn.addEventListener('click', () => {
    currentTheme = currentTheme === 'light' ? 'dark' : 'light';
    updateContent();
});

// Initialize
// Check system preference for dark mode
if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
    currentTheme = 'dark';
}
// Check browser language
const userLang = navigator.language || navigator.userLanguage;
if (userLang.startsWith('zh')) {
    currentLang = 'zh';
}

updateContent();
startSlideshow();