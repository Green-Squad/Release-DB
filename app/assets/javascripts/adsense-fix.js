adsenseTurbolinksfix = {
  reset: function() {
    if (typeof adsbygoogle !== 'undefined') {
      // It's okay to use forEach since browsers that don't support it
      // don't support Turbolinks anyway. If browser doesn't support Turbolinks,
      // its events (hence this) won't be triggered.
      [
        "adk2_experiment",
        "async_config",
        "correlator",
        "exp_persistent",
        "iframe_oncopy",
        "jobrunner",
        "num_0ad_slots",
        "num_ad_slots",
        "num_reactive_ad_slots",
        "num_sdo_slots",
        "num_slot_to_show",
        "num_slots_by_channel",
        "onload_fired",
        "persistent_language",
        "persistent_state",
        "persistent_state_async",
        "prev_ad_formats_by_region",
        "prev_ad_slotnames_by_region",
        "pstate_expt",
        "pstate_rc_expt",
        "reactive_ads_global_state",
        "top_js_status",
        "unique_id",
        "viewed_host_channels"
      ].forEach(function(val) {
        delete window["google_" + val];
      });

      delete window.adsbygoogle;
    }
  },

  enable: function() {
    $(document).on("page:fetch", this.reset);
  }
};

adsenseTurbolinksfix.enable();