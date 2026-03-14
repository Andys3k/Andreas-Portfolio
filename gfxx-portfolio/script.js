const body = document.body;
const revealElements = document.querySelectorAll("[data-reveal]");
const cursorDot = document.querySelector(".cursor-dot");
const cursorRing = document.querySelector(".cursor-ring");
const hoverTargets = document.querySelectorAll("[data-cursor='hover']");
const projectCards = document.querySelectorAll(".project-card");
const projectVideos = document.querySelectorAll(".project-card .project-video");
const lightbox = document.querySelector(".project-lightbox");
const lightboxBackdrop = document.querySelector(".lightbox-backdrop");
const lightboxPanel = document.querySelector(".lightbox-panel");
const lightboxMedia = document.querySelector(".lightbox-media");
const lightboxInfo = document.querySelector(".lightbox-info");
const lightboxClose = document.querySelector(".lightbox-close");
const lightboxSoundToggle = document.querySelector(".lightbox-sound-toggle");
const langToggle = document.querySelector(".lang-toggle");
const languageStorageKey = "gfxx-portfolio-language";

const translations = {
  en: {
    navHome: "Home",
    navWork: "Portfolio",
    navServices: "Services",
    navAbout: "About",
    navContact: "Contact",
    heroRoleOne: "GRAPHIC DESIGNER",
    heroRoleTwo: "VIDEO EDITOR",
    instagramLabel: "Instagram:",
    viewWork: "View Portfolio",
    viewMore: "View More",
    workPreviewCopy: "A preview of selected projects. Open the full portfolio to explore all work.",
    panelKicker: "GFXX Studio",
    panelText: "Graphic design and video editing for creators, brands, and social media content.",
    tagDesign: "Graphic Design",
    tagEdit: "Video Editing",
    selectedWork: "Portfolio",
    project1Category: "Graphic Design",
    project1Title: "PerfectPain Poster Collage",
    project1Detail: "Poster design collection created for the clothing brand PerfectPain.",
    project2Category: "Video Editing",
    project2Title: "NoSleep Festival Edit",
    project2Detail: "Festival performance edit featuring Yzomandias and PTK.",
    project3Category: "Video Editing",
    project3Title: "Uwantsam x David Nunes",
    project3Detail: "Video edit for Uwantsam and David Nunes.",
    project4Category: "Video Editing",
    project4Title: "VibeEvents x StudentVibes",
    project4Detail: "Event promo edit created for VibeEvents and StudentVibes.",
    servicesTitle: "Services",
    service1Title: "Graphic Design",
    service1Detail: "Bold visuals, campaign systems, typography-led concepts, and premium brand assets.",
    service2Title: "Video Editing",
    service2Detail: "Fast-cut edits, cinematic pacing, social-first storytelling, and polished post-production.",
    service3Title: "Motion Graphics",
    service3Detail: "Animated type, transitions, UI-inspired sequences, and motion systems with impact.",
    service4Title: "Social Media Content",
    service4Detail: "Scroll-stopping templates, launch assets, reels packaging, and platform-native creative.",
    aboutTitle: "About",
    aboutP1: "My name is Andreas, a young graphic designer and video editor focused on creating bold, modern visuals for brands, creators, artists, and digital content.",
    aboutP2: "The focus is simple: build visuals that feel sharp, cinematic, and unmistakably current for brands, creators, and campaigns.",
    metric1Label: "Service",
    metric1Value: "Graphic Design",
    metric2Label: "Service",
    metric2Value: "Video Editing",
    metric3Label: "Approach",
    metric3Value: "Creative Direction",
    processTitle: "Process",
    process1Title: "Idea",
    process1Detail: "Concept framing, references, and creative direction.",
    process2Title: "Design",
    process2Detail: "Typography, layout, composition, and visual system building.",
    process3Title: "Edit",
    process3Detail: "Pacing, transitions, sound sync, and motion refinement.",
    process4Title: "Deliver",
    process4Detail: "Platform-ready exports and polished final presentation.",
    contactTitle: "Let's work together.",
    contactCopy: "Available for visual identity work, campaign edits, motion graphics, and social-first creative.",
    contactInstagram: "Instagram",
    startProject: "Start a Project",
    portfolioPageTitle: "Portfolio",
    portfolioIntro: "A focused selection of graphic design and video editing projects.",
  },
  cs: {
    navHome: "Domů",
    navWork: "Portfolio",
    navServices: "Služby",
    navAbout: "O mně",
    navContact: "Kontakt",
    heroRoleOne: "GRAFICKÝ DESIGNER",
    heroRoleTwo: "VIDEO EDITOR",
    instagramLabel: "Instagram:",
    viewWork: "Zobrazit portfolio",
    viewMore: "Zobrazit více",
    workPreviewCopy: "Ukázka vybraných projektů. Otevři celé portfolio a projdi si všechnu moji práci.",
    panelKicker: "GFXX Studio",
    panelText: "Grafický design a video editing pro tvůrce, značky a obsah na sociální sítě.",
    tagDesign: "Grafický Design",
    tagEdit: "Video Editing",
    selectedWork: "Portfolio",
    project1Category: "Grafický Design",
    project1Title: "PerfectPain Poster Collage",
    project1Detail: "Kolekce poster designů vytvořená pro clothing brand PerfectPain.",
    project2Category: "Video Editing",
    project2Title: "NoSleep Festival Edit",
    project2Detail: "Festivalový edit s umělci Yzomandias a PTK.",
    project3Category: "Video Editing",
    project3Title: "Uwantsam x David Nunes",
    project3Detail: "Video edit for Uwantsam and David Nunes.",
    project4Category: "Video Editing",
    project4Title: "VibeEvents x StudentVibes",
    project4Detail: "Event promo edit vytvořený pro VibeEvents a StudentVibes.",
    servicesTitle: "Služby",
    service1Title: "Grafický Design",
    service1Detail: "Výrazné vizuály, kampanové systémy, typografické koncepty a premium brand assety.",
    service2Title: "Video Editing",
    service2Detail: "Rychlý střih, filmové tempo, social-first storytelling a čistý postprodukční finish.",
    service3Title: "Motion Graphics",
    service3Detail: "Animovaná typografie, přechody, UI-inspired sekvence a motion systémy s dopadem.",
    service4Title: "Obsah Na Sociální Sítě",
    service4Detail: "Obsah, který zastaví scroll, launch assety, reels packaging a platform-native creative.",
    aboutTitle: "O mně",
    aboutP1: "Jmenuju se Andreas, jsem mladý grafický designer a video editor zaměřený na tvorbu bold a moderních vizuálů pro značky, tvůrce, artisty a digitální obsah.",
    aboutP2: "Cíl je jednoduchý: tvořit vizuály, které působí sharp, filmově a aktuálně pro značky, tvůrce a kampaně.",
    metric1Label: "Služba",
    metric1Value: "Grafický Design",
    metric2Label: "Služba",
    metric2Value: "Video Editing",
    metric3Label: "Přístup",
    metric3Value: "Creative Direction",
    processTitle: "Proces",
    process1Title: "Nápad",
    process1Detail: "Koncept, reference a kreativní směr.",
    process2Title: "Design",
    process2Detail: "Typografie, layout, kompozice a tvorba vizuálního systému.",
    process3Title: "Edit",
    process3Detail: "Tempo, přechody, sync se soundem a doladění motionu.",
    process4Title: "Odevzdání",
    process4Detail: "Exporty připravené pro platformy a čistá finální prezentace.",
    contactTitle: "Pojďme spolu pracovat.",
    contactCopy: "Dostupný pro visual identity, campaign edits, motion graphics a social-first creative.",
    contactInstagram: "Instagram",
    startProject: "Začít Projekt",
    portfolioPageTitle: "Portfolio",
    portfolioIntro: "Výběr projektů zaměřených na grafický design a video editing.",
  },
};

let activeLightboxVideo = null;
let activeLightboxCard = null;

window.addEventListener("load", () => {
  body.classList.add("is-loaded");
});

const applyLanguage = (lang) => {
  const dictionary = translations[lang] || translations.en;
  document.documentElement.lang = lang;

  document.querySelectorAll("[data-i18n]").forEach((element) => {
    const key = element.dataset.i18n;
    if (dictionary[key]) {
      element.textContent = dictionary[key];
    }
  });

  if (langToggle) {
    const isCzech = lang === "cs";
    langToggle.setAttribute("aria-pressed", String(isCzech));
    langToggle.textContent = isCzech ? "EN" : "CZ";
  }

  if (lightbox && lightbox.classList.contains("is-open")) {
    if (activeLightboxCard) {
      openLightbox(activeLightboxCard);
    }
  }
};

let currentLanguage = "en";

try {
  const savedLanguage = window.localStorage.getItem(languageStorageKey);
  if (savedLanguage && translations[savedLanguage]) {
    currentLanguage = savedLanguage;
  }
} catch (_error) {
  currentLanguage = "en";
}

revealElements.forEach((element) => {
  const delay = Number(element.dataset.delay || 0);
  element.style.setProperty("--delay", delay);
});

const revealObserver = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add("is-visible");
        revealObserver.unobserve(entry.target);
      }
    });
  },
  {
    threshold: 0.18,
    rootMargin: "0px 0px -10% 0px",
  }
);

revealElements.forEach((element) => revealObserver.observe(element));

if (window.matchMedia("(min-width: 721px)").matches && cursorDot && cursorRing) {
  const pointer = { x: window.innerWidth / 2, y: window.innerHeight / 2 };
  const ring = { x: pointer.x, y: pointer.y };

  window.addEventListener("mousemove", (event) => {
    pointer.x = event.clientX;
    pointer.y = event.clientY;
    cursorDot.style.transform = `translate(${pointer.x}px, ${pointer.y}px) translate(-50%, -50%)`;
  });

  const renderCursor = () => {
    ring.x += (pointer.x - ring.x) * 0.14;
    ring.y += (pointer.y - ring.y) * 0.14;
    cursorRing.style.transform = `translate(${ring.x}px, ${ring.y}px) translate(-50%, -50%)`;
    requestAnimationFrame(renderCursor);
  };

  renderCursor();

  hoverTargets.forEach((target) => {
    target.addEventListener("mouseenter", () => {
      cursorRing.classList.add("is-hovering");
    });

    target.addEventListener("mouseleave", () => {
      cursorRing.classList.remove("is-hovering");
    });
  });
}

const updateCardSoundState = (button, isMuted) => {
  button.setAttribute("aria-pressed", String(!isMuted));
  button.setAttribute("aria-label", isMuted ? "Turn sound on" : "Turn sound off");
};

document.querySelectorAll(".project-card").forEach((card) => {
  const video = card.querySelector(".project-video");
  const button = card.querySelector(".sound-toggle");

  if (!video || !button) {
    return;
  }

  updateCardSoundState(button, true);

  button.addEventListener("click", async (event) => {
    event.stopPropagation();
    const shouldEnableSound = video.muted;
    video.muted = !shouldEnableSound;
    updateCardSoundState(button, !shouldEnableSound);

    try {
      await video.play();
    } catch (_error) {
      video.muted = true;
      updateCardSoundState(button, true);
    }
  });
});

const videoObserver = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      const video = entry.target;
      if (!(video instanceof HTMLVideoElement)) {
        return;
      }

      if (entry.isIntersecting) {
        video.play().catch(() => {});
      } else {
        video.pause();
      }
    });
  },
  {
    threshold: 0.35,
  }
);

projectVideos.forEach((video) => {
  videoObserver.observe(video);
});

const updateLightboxSoundState = (isMuted) => {
  if (!lightboxSoundToggle) {
    return;
  }

  lightboxSoundToggle.setAttribute("aria-pressed", String(!isMuted));
  lightboxSoundToggle.setAttribute("aria-label", isMuted ? "Turn sound on" : "Turn sound off");
};

const closeLightbox = () => {
  if (!lightbox || !lightbox.classList.contains("is-open")) {
    return;
  }

  lightbox.classList.remove("is-open");
  lightbox.setAttribute("aria-hidden", "true");
  body.classList.remove("modal-open");

  if (activeLightboxVideo) {
    activeLightboxVideo.pause();
    activeLightboxVideo = null;
  }

  projectVideos.forEach((video) => {
    const rect = video.getBoundingClientRect();
    const isVisible = rect.top < window.innerHeight && rect.bottom > 0;
    if (isVisible) {
      video.play().catch(() => {});
    }
  });
  activeLightboxCard = null;

  if (lightboxMedia) {
    lightboxMedia.innerHTML = "";
  }

  if (lightboxSoundToggle) {
    lightboxSoundToggle.hidden = true;
    updateLightboxSoundState(true);
  }
};

const openLightbox = (card) => {
  if (!lightbox || !lightboxMedia || !lightboxInfo) {
    return;
  }

  activeLightboxCard = card;

  const media = card.querySelector(".project-media");
  const category = card.querySelector(".project-category")?.textContent || "";
  const title = card.querySelector("h3")?.textContent || "";
  const detail = card.querySelector(".project-detail")?.textContent || "";

  lightboxMedia.innerHTML = "";
  activeLightboxVideo = null;

  if (media?.tagName === "VIDEO") {
    const video = media.cloneNode(true);
    video.classList.add("lightbox-video");
    video.controls = false;
    video.muted = true;
    video.autoplay = true;
    video.loop = true;
    video.playsInline = true;
    lightboxMedia.appendChild(video);
    activeLightboxVideo = video;
    lightboxSoundToggle.hidden = false;
    updateLightboxSoundState(true);
    video.play().catch(() => {});
  } else if (media) {
    const mediaClone = media.cloneNode(true);
    lightboxMedia.appendChild(mediaClone);
    lightboxSoundToggle.hidden = true;
  }

  lightboxInfo.querySelector(".project-category").textContent = category;
  lightboxInfo.querySelector("h3").textContent = title;
  lightboxInfo.querySelector(".project-detail").textContent = detail;

  lightbox.classList.add("is-open");
  lightbox.setAttribute("aria-hidden", "false");
  body.classList.add("modal-open");
  projectVideos.forEach((video) => video.pause());
};

projectCards.forEach((card) => {
  card.addEventListener("click", (event) => {
    if (event.target.closest(".sound-toggle")) {
      return;
    }

    openLightbox(card);
  });
});

if (lightboxSoundToggle) {
  lightboxSoundToggle.addEventListener("click", async (event) => {
    event.stopPropagation();

    if (!activeLightboxVideo) {
      return;
    }

    const shouldEnableSound = activeLightboxVideo.muted;
    activeLightboxVideo.muted = !shouldEnableSound;
    updateLightboxSoundState(!shouldEnableSound);

    try {
      await activeLightboxVideo.play();
    } catch (_error) {
      activeLightboxVideo.muted = true;
      updateLightboxSoundState(true);
    }
  });
}

lightboxBackdrop?.addEventListener("click", closeLightbox);
lightboxClose?.addEventListener("click", closeLightbox);
lightboxPanel?.addEventListener("click", (event) => event.stopPropagation());

langToggle?.addEventListener("click", () => {
  currentLanguage = currentLanguage === "en" ? "cs" : "en";
  try {
    window.localStorage.setItem(languageStorageKey, currentLanguage);
  } catch (_error) {
    // Ignore storage errors and continue with in-memory language switching.
  }
  applyLanguage(currentLanguage);
});

window.addEventListener("keydown", (event) => {
  if (event.key === "Escape") {
    closeLightbox();
  }
});

applyLanguage(currentLanguage);
