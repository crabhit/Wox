using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using System.Windows;
using Squirrel;
using Wox.CommandArgs;
using Wox.Core.Plugin;
using Wox.Helper;
using Wox.Infrastructure.Image;
using Wox.ViewModel;
using Stopwatch = Wox.Infrastructure.Stopwatch;
using Wox.Infrastructure.Logger;

namespace Wox
{
    public partial class App : ISingleInstanceApp
    {
        private const string Unique = "Wox_Unique_Application_Mutex";
        public static MainWindow Window { get; private set; }
        public static PublicAPIInstance API { get; private set; }
        private bool _saved;
        private Task<UpdateManager> _updater;
        private NotifyIconManager _notifyIcon;

        [STAThread]
        public static void Main()
        {
            RegisterAppDomainUnhandledException();
            if (SingleInstance<App>.InitializeAsFirstInstance(Unique))
            {
                var application = new App();
                application.InitializeComponent();
                application.Run();
                SingleInstance<App>.Cleanup();
            }
        }

        protected override void OnStartup(StartupEventArgs e)
        {
            Stopwatch.Debug("Startup Time", () =>
            {
                base.OnStartup(e);

                RegisterDispatcherUnhandledException();

                ImageLoader.PreloadImages();

                MainViewModel mainVM = new MainViewModel();
                var pluginsSettings = mainVM._settings.PluginSettings;
                API = new PublicAPIInstance(mainVM, mainVM._settings);
                PluginManager.InitializePlugins(API, pluginsSettings);

                Window = new MainWindow(mainVM._settings, mainVM);
                _notifyIcon = new NotifyIconManager(API);
                CommandArgsFactory.Execute(e.Args.ToList());
            });
        }
        private void OnActivated(object sender, EventArgs e)
        {
            try
            {
                Task.Run(() =>
                {
                    using (_updater = UpdateManager.GitHubUpdateManager("https://github.com/Wox-launcher/Wox"))
                    {
                        _updater.Result.UpdateApp().Wait();
                    }
                });
            }
            catch (Exception exception)
            {
                Log.Error(exception);
            }
        }

        [Conditional("RELEASE")]
        private void RegisterDispatcherUnhandledException()
        {
            // let exception throw as normal is better for Debug 
            DispatcherUnhandledException += ErrorReporting.DispatcherUnhandledException;
        }

        [Conditional("RELEASE")]
        private static void RegisterAppDomainUnhandledException()
        {
            // let exception throw as normal is better for Debug 
            AppDomain.CurrentDomain.UnhandledException += ErrorReporting.UnhandledExceptionHandle;
        }

        public void OnActivate(IList<string> args)
        {
            if (args.Count > 0 && args[0] == SingleInstance<App>.Restart)
            {
                API.CloseApp();
            }
            else
            {
                CommandArgsFactory.Execute(args);
            }
        }

        private void OnExit(object sender, ExitEventArgs e)
        {
            Save();
            _updater.Dispose();
        }

        private void OnSessionEnding(object sender, SessionEndingCancelEventArgs e)
        {
            Save();
            _updater.Dispose();
        }

        private void Save()
        {
            // if sessionending is called, exit proverbially be called when log off / shutdown
            // but if sessionending is not called, exit won't be called when log off / shutdown
            if (!_saved)
            {
                var vm = (MainViewModel)Window.DataContext;
                vm.Save();
                PluginManager.Save();
                ImageLoader.Save();
                _saved = true;
            }
        }


    }
}
