/*
 * Copyright (C) 2019 The Turms Project
 * https://github.com/turms-im/turms
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package im.turms.service.domain.blocklist.access.admin.dto.response;

import java.util.Date;
import java.util.Objects;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import im.turms.server.common.domain.blocklist.bo.BlockedClient;
import im.turms.server.common.domain.common.access.dto.ControllerDTO;
import im.turms.server.common.infra.lang.ByteArrayWrapper;
import im.turms.server.common.infra.net.InetAddressUtil;

/**
 * @author James Chen
 */
@Accessors(fluent = true)
@EqualsAndHashCode(callSuper = true)
@Data
public class BlockedIpDTO implem
{
    private final String id;
    private final Date blockEndTime;

    /**
     *
     */
    public BlockedIpDTO(String id, Date blockEndTime) {
        this.id = id;
        this.blockEndTime = blockEndTime;
    }

    public static BlockedIpDTO from(BlockedClient<ByteArrayWrapper> blockedClient) {
        return new BlockedIpDTO(
                InetAddressUtil.ipBytesToString(blockedClient.id()
                        .getBytes()),
                new Date(blockedClient.blockEndTimeMillis()));
    }

    public String id() {
        return id;
    }

    public Date blockEndTime() {
        return blockEndTime;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this)
            return true;
        if (obj == null || obj.getClass() != this.getClass())
            return false;
        var that = (BlockedIpDTO) obj;
        return Objects.equals(this.id, that.id)
                && Objects.equals(this.blockEndTime, that.blockEndTime);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, blockEndTime);
    }

    @Override
    public String toString() {
        return "BlockedIpDTO["
                + "id="
                + id
                + ", "
                + "blockEndTime="
                + blockEndTime
                + ']';
    }

}