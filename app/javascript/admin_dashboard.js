$(document).ready(() => {
  const tabButtons = $('.tab-button');
  const contentSections = $('.music-manager-content-section');
  const addArtistDrawerButton = $('#add_artist_drawer_btn');


  // ADD Artist Drawer
  const drawer = $('#drawer');
  const drawerOverlay = $('#drawerOverlay');
  // const createForm = $('#createForm');
  const body = $('body');


  const avatarInput = $('#avatar');
  const avatarPreview = $('#avatarPreview');
  const addArtistForm = $('#add_artist_form');
  const drawerCloseButton = $('.drawer-close');


  tabButtons.on('click', function() {
    tabButtons.removeClass('active');
    contentSections.removeClass('active');
    
    $(this).addClass('active');
    const tabId = $(this).data('tab');
    $(`#${tabId}`).addClass('active');
  });

  addArtistDrawerButton.on('click', function() {
    openDrawer();
  });

  drawerCloseButton.on('click', function() {
    closeDrawer();
  });

  addArtistForm.on('change', function(e) {
    const watchedFields = ['name', 'email'];
    if (watchedFields.includes(e.target.name)) {
        validate_fields(e);
    }
});

addArtistForm.on('input', function() {
    if (validate_name_field() || validate_email_field()) {
        $('#add_artist_btn').attr('disabled', true);
    } else {
        $('#add_artist_btn').removeAttr('disabled');
    }
});

function validate_name_field() {
    var name_value = $('#name').val();
    return name_value.length < 3;
}

function validate_email_field() {
    var email_value = $('#email').val();
    var email_regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,})+$/;
    return !email_regex.test(email_value);
}

function validate_fields(event) {
    var $errorElement = $(event.target).closest('.form-group').find('.validation-error');
    
    if (event.target.name == "name") {
        if (validate_name_field()) {
            $errorElement.show();
        } else {
            $errorElement.hide();
        }
    }
    
    if (event.target.name == "email") {
        if (validate_email_field()) {
            $errorElement.show();
        } else {
            $errorElement.hide();
        }
    }
}

  function openDrawer() {
    drawer.addClass('open');
    drawerOverlay.addClass('open');
    body.css('overflow', 'hidden');




  }
  
  function closeDrawer() {
    drawer.removeClass('open');
    drawerOverlay.removeClass('open');
    body.css('overflow', 'auto');

  }

  avatarPreview.on('click', function() {
      avatarInput.trigger('click');
  });

  avatarInput.on('change', function() {
    const file = this.files[0];
      if (file) {
          const reader = new FileReader();
          reader.onload = function(e) {
              avatarPreview.css('background-image', `url(${e.target.result})`);
          }
          reader.readAsDataURL(file);
      }
  });



  flatpickr("#dob", {
    dateFormat: "d-m-y",
    altInput: true,
    altFormat: "F j, Y",
    maxDate: "today"
  });

  // Add Artist Ajax call
//   $('#add_artist_btn').on('submit', function(e) {
//     e.preventDefault();
//     const formData = new FormData($("#add_artist_form")[0]);
//     console.log(formData);

//     $.ajax({
//         url: 'artists',
//         type: 'POST',
//         data: formData,
//     })
//     .done(function(response) {
//         // if (response.success) {
//         //     closeDrawer();
//         //     $('#success_message').show();
//         // }
//     })
//     .fail(function(jqXHR, textStatus, errorThrown) {
//         // // Handle errors
//         // $('#error_message').show();
//         // console.log('Error:', errorThrown);
//     })
//     .always(function() {
//         // // This will run regardless of success or failure
//         // addArtistForm[0].reset();
//         // $('#add_artist_btn').removeAttr('disabled');
//     });

// });

$(document).on('submit', '#add_artist_form', function(e) {
  e.preventDefault();
  showDrawerLoader();

  // Create a new FormData object
  const formData = new FormData();
    
  // Add fields under the "user" namespace
  formData.append('user[name]', $('#name').val());
  formData.append('user[email]', $('#email').val());
  formData.append('user[dob]', $('#dob').val());
  
  // Add the avatar file if it exists
  const avatarFile = $('#avatar')[0].files[0];
  if (avatarFile) {
      formData.append('user[avatar]', avatarFile);
  }

  // Add fields under the "artist" namespace
  formData.append('artist[bio]', $('#bio').val());


  $.ajax({
    type: "POST",
    url: 'artists',
    // crossDomain: true,
    data: formData,
    // dataType: "json",
    processData: false,
    contentType: false
    // headers: {
    //   "Accept": "application/json"
    // }
  }).done(function(response) {
    // debugger
    if (response.status === "success") {
      // debugger
      reRenderArtists();
      closeDrawer();
      // $('#success_message').show();
    }
    else if (response.status === 'error'){
      appendAlert(response.message);
    }
    //  $('.success').addClass('is-active');
  }).fail(function(jqXHR) {
    // debugger
    //  alert('An error occurred! Please try again later.')
    // const response = jqXHR.responseJSON;
    //     $('#error_message').text(response.message).show();
  })
  .always(function() {
    hideDrawerLoader();
    //         // // This will run regardless of success or failure
    //         // addArtistForm[0].reset();
    //         // $('#add_artist_btn').removeAttr('disabled');
  });
// your ajax code
});

function reRenderArtists(){
  $.ajax({
    type: "GET",
    url: 'all_artists',
    // crossDomain: true,
    // data: formData,
    // dataType: "json",
    processData: false,
    contentType: false
    // headers: {
    //   "Accept": "application/json"
    // }
  }).done(function(response) {
    // debugger
    $('.artist-table-container').html(response);
  }).fail(function(jqXHR) {
    // debugger
     alert('An error occurred! Please try again later.');
    // const response = jqXHR.responseJSON;
    //     $('#error_message').text(response.message).show();
  })
}


const appendAlert = (messages) => {
const $wrapper = $('<div>');
const $alertContainer = $('<div>', {
  id: 'ajax-error-container',
  class: 'alert alert-danger alert-dismissible',
  role: 'alert'
});

const $closeButton = $('<button>', {
  type: 'button',
  class: 'btn-close',
  'data-bs-dismiss': 'alert',
  'aria-label': 'Close'
});

// Add error messages
messages.forEach((error, index) => {
  $('<div>')
    .text(`${index + 1}. ${error}`)
    .appendTo($alertContainer);
});

// Append close button and container to wrapper
$alertContainer.append($closeButton);
$wrapper.append($alertContainer);

// Append to placeholder
$('#ajaxErrorPlaceHolder').append($wrapper);
};


function showDrawerLoader() {
  $('.drawer-loader-container').css('display', 'flex');
  $('#add_artist_btn').prop('disabled', true); // Disable the submit button
}

function hideDrawerLoader() {
  $('.drawer-loader-container').hide();
  $('#add_artist_btn').prop('disabled', false); // Re-enable the submit button
}


});
