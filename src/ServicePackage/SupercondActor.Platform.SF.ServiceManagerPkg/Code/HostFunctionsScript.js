return async function (hostFunctions_a34efe7d1bf2496fa15560fb788db7f4, cb) {

    global._SupercondActor = {
        Logger: {
            logVerbose: function (arg) {
                hostFunctions_a34efe7d1bf2496fa15560fb788db7f4.LogVerbose(arg, function (error, result) { if (error) throw error; });
            },
            logInfo: function (arg) {
                hostFunctions_a34efe7d1bf2496fa15560fb788db7f4.LogInfo(arg, function (error, result) { if (error) throw error; });
            },
            logWarning: function (arg) {
                hostFunctions_a34efe7d1bf2496fa15560fb788db7f4.LogWarning(arg, function (error, result) { if (error) throw error; });
            },
            logError: function (arg) {
                hostFunctions_a34efe7d1bf2496fa15560fb788db7f4.LogError(arg, function (error, result) { if (error) throw error; });
            }
        },
        Context: {
            saveLocalStateAsync: function (key, value) {
                return new Promise(function (resolve, reject) {
                    try {
                        let json = value === null ? null : JSON.stringify(value);
                        hostFunctions_a34efe7d1bf2496fa15560fb788db7f4.SaveState({ key: key, value: json }, function (error, result) {
                            if (error) {
                                reject(error);
                            }
                            else {
                                try {
                                    let resObj = result === null ? null : JSON.parse(result);
                                    resolve(resObj);
                                } catch (e) {
                                    reject(e);
                                }
                            }
                        });
                    } catch (er) {
                        reject(er);
                    }
                });
            },
            getLocalStateAsync: function (key) {
                return new Promise(function (resolve, reject) {
                    try {
                        hostFunctions_a34efe7d1bf2496fa15560fb788db7f4.GetState(key, function (error, result) {
                            if (error) {
                                reject(error);
                            }
                            else {
                                try {
                                    let resObj = result === null ? null : JSON.parse(result);
                                    resolve(resObj);
                                } catch (e) {
                                    reject(e);
                                }
                            }
                        });
                    } catch (er) {
                        reject(er);
                    }
                });
            },
            getServiceDescriptorAsync: function () {
                return new Promise(function (resolve, reject) {
                    try {
                        hostFunctions_a34efe7d1bf2496fa15560fb788db7f4.GetServiceDescriptor('', function (error, result) {
                            if (error) {
                                reject(error);
                            }
                            else {
                                try {
                                    let resObj = !result ? null : JSON.parse(result);
                                    resolve(resObj);
                                } catch (e) {
                                    reject(e);
                                }
                            }
                        });
                    } catch (er) {
                        reject(er);
                    }
                });
            }
        }
    };

    if (hostFunctions_a34efe7d1bf2496fa15560fb788db7f4.OverrideConsole) {
        console.assert = function () {
            if (arguments.length <= 0 || !!arguments[0]) {
                return;
            }
            var args = [];
            for (var i = 1; i < arguments.length; i++) {
                args.push(arguments[i]);
            }
            var trace = (new Error()).stack.substr(5);
            trace = trace.substring(trace.indexOf("\n", trace.indexOf("\n") + 1) + 1);
            args.push('Trace:\n' + trace);
            global._SupercondActor.Logger.LogWarning(args);
        };
        console.debug = function () {
            var args = [];
            for (var i = 0; i < arguments.length; i++) {
                args.push(arguments[i]);
            }
            global._SupercondActor.Logger.logVerbose(args);
        };
        console.error = function () {
            var args = [];
            for (var i = 0; i < arguments.length; i++) {
                args.push(arguments[i]);
            }
            global._SupercondActor.Logger.logError(args);
        };
        console.exception = function () {
            var args = [];
            for (var i = 0; i < arguments.length; i++) {
                args.push(arguments[i]);
            }
            global._SupercondActor.Logger.logError(args);
        };
        console.info = function () {
            var args = [];
            for (var i = 0; i < arguments.length; i++) {
                args.push(arguments[i]);
            }
            global._SupercondActor.Logger.logInfo(args);
        };
        console.log = function () {
            var args = [];
            for (var i = 0; i < arguments.length; i++) {
                args.push(arguments[i]);
            }
            global._SupercondActor.Logger.logInfo(args);
        };
        console.trace = function () {
            var args = [];
            for (var i = 0; i < arguments.length; i++) {
                args.push(arguments[i]);
            }
            var trace = (new Error()).stack;
            trace = trace.substring(trace.indexOf("\n", trace.indexOf("\n") + 1) + 1);
            args.push('Trace:\n' + trace);
            global._SupercondActor.Logger.logInfo(args);
        };
        console.warn = function () {
            var args = [];
            for (var i = 0; i < arguments.length; i++) {
                args.push(arguments[i]);
            }
            global._SupercondActor.Logger.logWarning(args);
        };
    }

    try {
        let SupercondActor_HostedScript_a34efe7d1bf2496fa15560fb788db7f4 = async function () {
            //[ExternalScript]
        };

        let resJson = null;
        let result = await SupercondActor_HostedScript_a34efe7d1bf2496fa15560fb788db7f4();

        if (result !== undefined) {
            resJson = JSON.stringify(result);
        }
        cb(null, resJson);
    } catch (e) {
        cb(e, null);
    }
};