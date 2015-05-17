/* gnome-tasks.vala
 *
 * Copyright (C) 2015 Igor Gnatenko <i.gnatenko.brain@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

public class Tasks : Gtk.Application
{
  /* Settings keys */
  private Settings settings;

  /* Main window */
  private Gtk.Window window;
  private int window_width;
  private int window_height;
  private bool is_maximized;

  private const GLib.ActionEntry[] action_entries =
  {
    { "about", about_cb },
    { "quit",  quit_cb  }
  };

  public Tasks ()
  {
    Object (application_id: "org.gnome.tasks", flags: ApplicationFlags.FLAGS_NONE);
  }

  protected override void startup ()
  {
    base.startup ();

    Environment.set_application_name ("Tasks");

    settings = new Settings ("org.gnome.tasks");
    settings.delay ();

    var ui_builder = new Gtk.Builder ();
    try {
      ui_builder.add_from_file (Path.build_filename (DATA_DIRECTORY, "interface.ui", null));
    } catch (Error e) {
      warning ("Could not load app UI: %s", e.message);
    }

    add_action_entries (action_entries, this);

    window = (Gtk.ApplicationWindow) ui_builder.get_object ("main_window");
    window.set_default_size (settings.get_int ("window-width"), settings.get_int ("window-height"));
    if (settings.get_boolean ("window-is-maximized"))
      window.maximize ();
    add_window (window);

    var menu = new Menu ();
    var section = new Menu ();
    menu.append_section (null, section);
    section.append ("About", "app.about");
    section.append ("Quit", "app.quit");
    set_app_menu (menu);
    set_accels_for_action ("app.quit", {"<Primary>q"});
  }

  public void start ()
  {
    window.show ();
  }

  protected override void shutdown ()
  {
    base.shutdown ();

    /* Save window state */
    settings.set_int ("window-width", window_width);
    settings.set_int ("window-height", window_height);
    settings.set_boolean ("window-is-maximized", is_maximized);
    settings.apply ();
  }

  protected override void activate ()
  {
    window.present ();
  }

  private void quit_cb ()
  {
    window.destroy ();
  }

  private void about_cb ()
  {
    string[] authors = {
      "Igor Gnatenko",
      null
    };
    Gtk.show_about_dialog (window,
                           "name", "Tasks",
                           "copyright", "Copyright © 2015 Igor Gnatenko",
                           "license-type", Gtk.License.GPL_3_0,
                           "authors", authors,
                           null);
  }

  public static int main (string[] args)
  {
    var app = new Tasks ();
    return app.run (args);
  }
}
