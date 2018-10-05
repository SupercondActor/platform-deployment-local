declare var _SupercondActor: {
    /**
    * @returns {IPlatformLogger} - logger object writing messages to the service fabric ETW provider
    */
    Logger: _SupercondActor.IPlatformLogger;

    /**
    * @returns {IPlatformContext} - context object allowing communications with the underlying service fabric actor
    */
    Context: _SupercondActor.IPlatformContext;
};
declare namespace _SupercondActor {
    export interface IPlatformLogger {
        public logVerbose(args: any): void;
        public logInfo(args: any): void;
        public logWarning(args: any): void;
        public logError(args: any): void;
    }

    export interface IPlatformContext {
        public saveLocalStateAsync(key: string, value: any): Promise<any>;

        /**
        * @param {string} key - dictionary key for the state value
        * @returns {Promise<any>} - local state value for the provided key
        */
        public getLocalStateAsync(key: string): Promise<any>;
        public getServiceDescriptorAsync(): Promise<IPlatformServiceDescriptorInfo>;
    }

    export interface IPlatformServiceDescriptorInfo {
        public currentAppVersion: string;
        public descriptor: IPlatformServiceDescriptor;
    }

    export interface IPlatformServiceDescriptor {
        public serviceID: string;
        public serviceName: string;
        public groupName: string;
        public metadataJson: string;
        public job: IPlatformJobDescriptor;
        public removalRequested: boolean;
    }

    export interface IPlatformJobDescriptor {
        public jobScript: string;
        public jobSchedule: IPlatformJobSchedule;
        public stopRequested: boolean;
    }

    export interface IPlatformJobSchedule {
        public cronString?: string;
        public intervalSeconds?: number;
        public timeoutSeconds?: number;
    }
}
