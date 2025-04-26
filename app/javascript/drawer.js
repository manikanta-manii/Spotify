class Drawer {
  constructor({ width = "300px", templateNode = null }) {
    this.id = templateNode?.id || null;
    this.width = width;
    this.templateNode = templateNode;
    this.buildDrawer(this.id);
    Drawer.current = this;
  }

  buildDrawer(drawerId) {
    this.overlay = document.createElement("div");
    this.overlay.className = "drawer-overlay";

    this.drawer = document.createElement("div");
    this.drawer.id = drawerId;
    this.drawer.className = "drawer-component";
    this.drawer.style.width = this.width;

    const headerSlot = this.templateNode.querySelector('[slot="header"]');
    const contentSlot = this.templateNode.querySelector('[slot="content"]');
    const footerSlot = this.templateNode.querySelector('[slot="footer"]');

    const header = document.createElement("div");
    header.className = "drawer-header";
    if (headerSlot) header.appendChild(headerSlot.cloneNode(true));

    const closeBtn = document.createElement("span");
    closeBtn.className = "close-btn";
    closeBtn.innerHTML = "&times;";
    closeBtn.onclick = () => this.close();
    header.appendChild(closeBtn);

    const content = document.createElement("div");
    content.className = "drawer-content";
    if (contentSlot) content.appendChild(contentSlot.cloneNode(true));

    const footer = document.createElement("div");
    footer.className = "drawer-footer";
    if (footerSlot) footer.appendChild(footerSlot.cloneNode(true));

    this.drawer.appendChild(header);
    this.drawer.appendChild(content);
    this.drawer.appendChild(footer);
  }

  open() {
    document.body.appendChild(this.overlay);
    document.body.appendChild(this.drawer);

    this.drawer.querySelectorAll(".close-drawer-btn").forEach((btn) => {
      btn.addEventListener("click", () => this.close());
    });

    setTimeout(() => {
      this.overlay.classList.add("show");
      this.drawer.classList.add("open");
    }, 10);
  }

  close() {
    this.overlay.classList.remove("show");
    this.drawer.classList.remove("open");
    setTimeout(() => {
      this.overlay.remove();
      this.drawer.remove();
    }, 300);
    Drawer.current = null;
  }

  static openFromTemplate(selector, width = "300px") {
    const node = document.querySelector(selector);
    if (!node) {
      console.error(`Drawer template not found: ${selector}`);
      return;
    }
    const drawer = new Drawer({ width, templateNode: node });
    drawer.open();
  }
}
//   function handleSave() {
//     if (Drawer.current) {
//       alert('Saving drawer with ID: ' + Drawer.current.id);
//       // you can handle logic based on drawer.current.id
//       Drawer.current.close();
//     }
//   }
