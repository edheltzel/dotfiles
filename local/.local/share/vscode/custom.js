document.addEventListener('DOMContentLoaded', () => {
  const COMMAND_DIALOG_SELECTOR = '.quick-input-widget';
  const WORKBENCH_SELECTOR = '.monaco-workbench';
  const BLUR_ELEMENT_ID = 'command-blur';
  const CHECK_INTERVAL = 500;

  let observer;

  function createBlurElement() {
    const targetDiv = document.querySelector(WORKBENCH_SELECTOR);
    const existingElement = document.getElementById(BLUR_ELEMENT_ID);

    if (existingElement) {
      existingElement.remove();
    }

    if (!targetDiv) {
      return;
    }

    const newElement = document.createElement('div');
    newElement.id = BLUR_ELEMENT_ID;
    newElement.addEventListener('click', () => newElement.remove());
    targetDiv.appendChild(newElement);
  }

  function handleEscape() {
    document.getElementById(BLUR_ELEMENT_ID)?.remove();
  }

  function observeCommandDialog(commandDialog) {
    observer = new MutationObserver((mutations) => {
      for (const mutation of mutations) {
        if (mutation.type === 'attributes' && mutation.attributeName === 'style') {
          commandDialog.style.display === 'none' ? handleEscape() : createBlurElement();
          break;
        }
      }
    });

    observer.observe(commandDialog, { attributes: true });
  }

  function initCommandDialogObserver() {
    const commandDialog = document.querySelector(COMMAND_DIALOG_SELECTOR);
    if (commandDialog) {
      observeCommandDialog(commandDialog);
      return true;
    }
    return false;
  }

  const checkElement = setInterval(() => {
    if (initCommandDialogObserver()) {
      clearInterval(checkElement);
    }
  }, CHECK_INTERVAL);

  document.addEventListener('keydown', (event) => {
    if ((event.metaKey || event.ctrlKey) && event.key === 'p') {
      event.preventDefault();
      createBlurElement();
    } else if (event.key === 'Escape') {
      handleEscape();
    }
  });
});
