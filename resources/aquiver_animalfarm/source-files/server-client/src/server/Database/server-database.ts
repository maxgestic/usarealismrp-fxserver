import { AnimalBaseRepository } from './models/model-animal';
import { CompostsBaseRepository } from './models/model-composts';
import { FarmBaseRepository } from './models/model-farm-base';
import { PaddockBaseRepository } from './models/model-paddock';

export class ServerDatabase {
    static FarmRepository = new FarmBaseRepository('af_farms_base');
    static AnimalRepository = new AnimalBaseRepository('af_paddock_animals');
    static CompostsRepository = new CompostsBaseRepository('af_composts');
    static PaddockRepository = new PaddockBaseRepository('af_paddock_upgrades');
}